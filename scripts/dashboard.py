#!/usr/bin/env python3
"""
SPEC-IT Dashboard - Curses-based real-time monitoring
Usage: python3 dashboard.py [session_path]
"""

import curses
import json
import os
import subprocess
import sys
from datetime import datetime
from pathlib import Path


class Dashboard:
    def __init__(self, session_path: str):
        self.session_path = Path(session_path)
        self.status_file = self.session_path / "_status.json"
        self.state_file = self.session_path / "_state.json"
        self.meta_file = self.session_path / "_meta.json"

    def read_json(self, filepath: Path) -> dict:
        try:
            with open(filepath, 'r') as f:
                return json.load(f)
        except:
            return {}

    def get_status(self) -> dict:
        status = self.read_json(self.status_file)
        state = self.read_json(self.state_file)
        meta = self.read_json(self.meta_file)

        # Merge with smart array handling: prefer non-empty arrays
        result = {**meta, **status, **state}

        # For arrays, prefer non-empty version from any source
        for key in ['completedSteps', 'completedPhases', 'agents', 'errors', 'recentFiles']:
            values = [
                meta.get(key, []),
                status.get(key, []),
                state.get(key, [])
            ]
            # Use the longest (most populated) array
            non_empty = [v for v in values if isinstance(v, list) and len(v) > 0]
            if non_empty:
                result[key] = max(non_empty, key=len)

        # For progress, use max value from status or calculated from meta
        status_progress = status.get('progress', 0)
        if status_progress and status_progress > 0:
            result['progress'] = status_progress

        return result

    def detect_mode(self, data: dict) -> str:
        if data.get('specSource') or data.get('qaAttempts') is not None:
            return 'execute'
        if '.spec-it/execute' in str(self.session_path):
            return 'execute'
        return 'spec-it'

    def format_duration(self, seconds: int) -> str:
        if seconds < 0:
            seconds = 0
        hours = seconds // 3600
        minutes = (seconds % 3600) // 60
        secs = seconds % 60
        return f"{hours:02d}:{minutes:02d}:{secs:02d}"

    def parse_iso_time(self, iso_str: str) -> datetime:
        try:
            if 'T' in iso_str:
                dt_part = iso_str.split('T')[0]
                time_part = iso_str.split('T')[1].split('+')[0].split('-')[0]
                if '.' in time_part:
                    time_part = time_part.split('.')[0]
                return datetime.strptime(f"{dt_part} {time_part}", '%Y-%m-%d %H:%M:%S')
        except:
            pass
        return datetime.now()

    def safe_addstr(self, stdscr, y, x, text, attr=0):
        height, width = stdscr.getmaxyx()
        if y < 0 or y >= height or x < 0 or x >= width:
            return
        max_len = width - x - 1
        if max_len <= 0:
            return
        try:
            stdscr.addstr(y, x, text[:max_len], attr)
        except curses.error:
            pass

    def draw_progress_bar(self, stdscr, y, x, bar_width, percent, color):
        if bar_width <= 0:
            return
        filled = int(bar_width * percent / 100)
        empty = bar_width - filled
        self.safe_addstr(stdscr, y, x, "█" * filled, color)
        self.safe_addstr(stdscr, y, x + filled, "░" * empty)

    def draw_overlay(self, stdscr, height, width, waiting_msg):
        box_width = min(50, width - 4)
        box_height = 12
        start_y = (height - box_height) // 2
        start_x = (width - box_width) // 2

        for yy in range(start_y, start_y + box_height):
            for xx in range(start_x, start_x + box_width):
                try:
                    stdscr.addch(yy, xx, ' ', curses.color_pair(6))
                except curses.error:
                    pass

        self.safe_addstr(stdscr, start_y, start_x, "╔" + "═" * (box_width - 2) + "╗", curses.color_pair(3) | curses.A_BOLD)
        self.safe_addstr(stdscr, start_y + box_height - 1, start_x, "╚" + "═" * (box_width - 2) + "╝", curses.color_pair(3) | curses.A_BOLD)
        for yy in range(start_y + 1, start_y + box_height - 1):
            self.safe_addstr(stdscr, yy, start_x, "║", curses.color_pair(3) | curses.A_BOLD)
            self.safe_addstr(stdscr, yy, start_x + box_width - 1, "║", curses.color_pair(3) | curses.A_BOLD)
            self.safe_addstr(stdscr, yy, start_x + 1, " " * (box_width - 2))

        exclaim_art = ["██", "██", "██", "  ", "██"]
        art_start_y = start_y + 2
        for i, line in enumerate(exclaim_art):
            cx = start_x + (box_width - len(line)) // 2
            self.safe_addstr(stdscr, art_start_y + i, cx, line, curses.color_pair(3) | curses.A_BOLD)

        msg = "USER INPUT REQUIRED"
        self.safe_addstr(stdscr, start_y + 8, start_x + (box_width - len(msg)) // 2, msg, curses.color_pair(3) | curses.A_BOLD)

        max_msg_len = box_width - 4
        if len(waiting_msg) > max_msg_len:
            waiting_msg = waiting_msg[:max_msg_len - 3] + "..."
        self.safe_addstr(stdscr, start_y + 9, start_x + (box_width - len(waiting_msg)) // 2, waiting_msg, curses.color_pair(5))

    def render_execute(self, stdscr, data, width, height):
        """Render EXECUTE mode dashboard"""
        CYAN = curses.color_pair(1)
        GREEN = curses.color_pair(2)
        YELLOW = curses.color_pair(3)
        RED = curses.color_pair(4)
        WHITE = curses.color_pair(5)

        # Phase definitions
        PHASES = {
            1: {'name': 'LOAD', 'desc': 'Loading specs'},
            2: {'name': 'PLAN', 'desc': 'Generating execution plan'},
            3: {'name': 'EXECUTE', 'desc': 'Implementing code'},
            4: {'name': 'QA', 'desc': 'Build & test loop'},
            5: {'name': 'VALIDATE', 'desc': 'Code review & security'}
        }

        # Steps per phase
        PHASE_STEPS = {
            1: ['1.1', '1.2'],
            2: ['2.1', '2.2'],
            3: ['3.1', '3.2', '3.3'],
            4: ['4.1', '4.2'],
            5: ['5.1', '5.2']
        }

        session_id = data.get('sessionId', 'unknown')
        current_phase = data.get('currentPhase', 1)
        current_step = data.get('currentStep', '1.1')
        completed_phases = data.get('completedPhases', [])
        # Normalize to integers
        completed_phases = [int(p) for p in completed_phases]
        qa_attempts = data.get('qaAttempts', 0)
        max_qa = data.get('maxQaAttempts', 5)
        spec_source = data.get('specSource', '-')
        completed_tasks = data.get('completedTasks', [])
        current_task = data.get('currentTask', '')
        status = data.get('status', 'in_progress')

        start_time_str = data.get('startedAt', data.get('startTime', ''))
        if start_time_str:
            start_time = self.parse_iso_time(start_time_str)
            runtime = max(0, int((datetime.now() - start_time).total_seconds()))
        else:
            runtime = 0

        y = 0

        # Header
        self.safe_addstr(stdscr, y, 0, "═" * (width - 1), GREEN)
        y += 1
        self.safe_addstr(stdscr, y, 2, "SPEC-IT EXECUTE", GREEN | curses.A_BOLD)
        runtime_str = f"Runtime: {self.format_duration(runtime)}"
        self.safe_addstr(stdscr, y, width - len(runtime_str) - 3, runtime_str, curses.A_BOLD)
        y += 1
        self.safe_addstr(stdscr, y, 0, "═" * (width - 1), GREEN)
        y += 2

        # Session & Source
        self.safe_addstr(stdscr, y, 2, f"Session: ", curses.A_BOLD)
        self.safe_addstr(stdscr, y, 11, session_id)
        self.safe_addstr(stdscr, y, 30, f"Source: ", curses.A_BOLD)
        self.safe_addstr(stdscr, y, 38, spec_source, CYAN)
        y += 2

        # Phase Progress Section
        self.safe_addstr(stdscr, y, 0, "─" * (width - 1))
        y += 1
        self.safe_addstr(stdscr, y, 2, "PHASES", curses.A_BOLD)
        y += 1

        bar_width = min(20, width - 35)
        total_progress = 0

        for phase_num, phase_info in PHASES.items():
            phase_steps = PHASE_STEPS.get(phase_num, [])
            is_complete = phase_num in completed_phases
            is_current = phase_num == current_phase and not is_complete
            is_future = phase_num > current_phase and not is_complete

            # Simple progress calculation (same as spec-it)
            if is_complete:
                progress = 100
            elif is_current and current_step:
                try:
                    step_index = phase_steps.index(current_step)
                    total_steps = len(phase_steps)
                    progress = int((step_index / total_steps) * 100) + int(50 / total_steps)
                except (ValueError, ZeroDivisionError):
                    progress = 10
            else:
                progress = 0

            total_progress += progress / 5  # 5 phases in execute mode

            # Phase indicator
            if is_complete:
                indicator = "✓"
                color = GREEN
            elif is_current:
                indicator = "►"
                color = YELLOW | curses.A_BOLD
            else:
                indicator = "○"
                color = WHITE

            self.safe_addstr(stdscr, y, 2, indicator, color)
            self.safe_addstr(stdscr, y, 4, f"{phase_num}.", color)
            self.safe_addstr(stdscr, y, 7, phase_info['name'], color)

            # Progress bar for each phase
            self.safe_addstr(stdscr, y, 18, "[")
            self.draw_progress_bar(stdscr, y, 19, bar_width, progress, GREEN if is_complete else YELLOW)
            self.safe_addstr(stdscr, y, 19 + bar_width, "]")
            self.safe_addstr(stdscr, y, 21 + bar_width, f"{progress:3d}%")
            y += 1

        y += 1

        # Overall Progress
        overall_progress = int(total_progress)
        if status == 'completed':
            overall_progress = 100
        self.safe_addstr(stdscr, y, 0, "─" * (width - 1))
        y += 1
        self.safe_addstr(stdscr, y, 2, "OVERALL", curses.A_BOLD)
        overall_bar_width = min(40, width - 20)
        self.safe_addstr(stdscr, y, 12, "[")
        self.draw_progress_bar(stdscr, y, 13, overall_bar_width, overall_progress, GREEN)
        self.safe_addstr(stdscr, y, 13 + overall_bar_width, f"] {overall_progress:3d}%")
        y += 2

        # Current Task Section
        self.safe_addstr(stdscr, y, 0, "─" * (width - 1))
        y += 1
        self.safe_addstr(stdscr, y, 2, "CURRENT TASK", curses.A_BOLD)
        y += 1

        if current_task:
            self.safe_addstr(stdscr, y, 4, f"► {current_task[:width-10]}", YELLOW)
        elif status == 'completed':
            self.safe_addstr(stdscr, y, 4, "All tasks completed", GREEN)
        else:
            phase_name = PHASES.get(current_phase, {}).get('name', 'Unknown')
            self.safe_addstr(stdscr, y, 4, f"Phase {current_phase}: {phase_name} - Step {current_step}", CYAN)
        y += 2

        # Stats Section
        self.safe_addstr(stdscr, y, 0, "─" * (width - 1))
        y += 1
        self.safe_addstr(stdscr, y, 2, "STATS", curses.A_BOLD)
        y += 1

        self.safe_addstr(stdscr, y, 4, f"Tasks: ")
        self.safe_addstr(stdscr, y, 11, str(len(completed_tasks)), GREEN)
        self.safe_addstr(stdscr, y, 11 + len(str(len(completed_tasks))), " completed")

        self.safe_addstr(stdscr, y, 30, f"QA: ")
        qa_color = RED if qa_attempts >= max_qa - 1 else YELLOW if qa_attempts > 0 else WHITE
        self.safe_addstr(stdscr, y, 34, f"{qa_attempts}/{max_qa}", qa_color)
        y += 2

        # Footer line (footer is handled by render_footer)
        self.safe_addstr(stdscr, y, 0, "═" * (width - 1), GREEN)

        return y

    def render_spec_it(self, stdscr, data, width, height):
        """Render SPEC-IT mode dashboard with phase progress bars"""
        CYAN = curses.color_pair(1)
        GREEN = curses.color_pair(2)
        YELLOW = curses.color_pair(3)
        RED = curses.color_pair(4)
        WHITE = curses.color_pair(5)

        # Phase definitions
        PHASES = {
            1: {'name': 'BRAINSTORM', 'desc': 'Design Brainstorming'},
            2: {'name': 'UI-ARCH', 'desc': 'UI Architecture'},
            3: {'name': 'REVIEW', 'desc': 'Critical Review'},
            4: {'name': 'TEST-SPEC', 'desc': 'Test Specification'},
            5: {'name': 'ASSEMBLY', 'desc': 'Final Assembly'},
            6: {'name': 'APPROVAL', 'desc': 'Final Approval'}
        }

        # Steps per phase for progress calculation
        PHASE_STEPS = {
            1: ['1.1', '1.2', '1.3', '1.4'],
            2: ['2.1', '2.2'],
            3: ['3.1', '3.2'],
            4: ['4.1'],
            5: ['5.1'],
            6: ['6.1']
        }

        session_id = data.get('sessionId', 'unknown')
        current_phase = data.get('currentPhase', 1)
        current_step = data.get('currentStep', '1.1')
        completed_steps = data.get('completedSteps', [])
        completed_phases = data.get('completedPhases', [])
        # Normalize to integers
        completed_phases = [int(p) for p in completed_phases]
        status = data.get('status', 'in_progress')

        start_time_str = data.get('startTime', data.get('lastCheckpoint', ''))
        if start_time_str:
            start_time = self.parse_iso_time(start_time_str)
            runtime = max(0, int((datetime.now() - start_time).total_seconds()))
        else:
            runtime = 0

        # Calculate stats
        files_count = 0
        lines_count = 0
        for md_file in self.session_path.glob('**/*.md'):
            if not md_file.name.startswith('_'):
                files_count += 1
                try:
                    lines_count += sum(1 for _ in open(md_file))
                except:
                    pass

        y = 0

        # Header
        self.safe_addstr(stdscr, y, 0, "═" * (width - 1), CYAN)
        y += 1
        self.safe_addstr(stdscr, y, 2, "SPEC-IT DASHBOARD", CYAN | curses.A_BOLD)
        runtime_str = f"Runtime: {self.format_duration(runtime)}"
        self.safe_addstr(stdscr, y, width - len(runtime_str) - 3, runtime_str, curses.A_BOLD)
        y += 1
        self.safe_addstr(stdscr, y, 0, "═" * (width - 1), CYAN)
        y += 2

        # Session info
        self.safe_addstr(stdscr, y, 2, f"Session: ", curses.A_BOLD)
        self.safe_addstr(stdscr, y, 11, session_id)
        y += 2

        # Phase Progress Section
        self.safe_addstr(stdscr, y, 0, "─" * (width - 1))
        y += 1
        self.safe_addstr(stdscr, y, 2, "PHASES", curses.A_BOLD)
        y += 1

        bar_width = min(20, width - 35)
        total_progress = 0

        for phase_num, phase_info in PHASES.items():
            phase_steps = PHASE_STEPS.get(phase_num, [])
            is_complete = phase_num in completed_phases or str(phase_num) in [str(p) for p in completed_phases] or (status == 'completed' and phase_num <= 6)
            is_current = phase_num == current_phase and not is_complete
            is_future = phase_num > current_phase and not is_complete

            # Simple progress calculation
            if is_complete:
                progress = 100
            elif is_current and current_step:
                # Calculate from currentStep position in phase_steps
                # e.g., currentStep="2.1", phase_steps=['2.1','2.2'] → index 0, total 2
                try:
                    step_index = phase_steps.index(current_step)
                    total_steps = len(phase_steps)
                    # Step in progress = (index / total) * 100 + partial
                    progress = int((step_index / total_steps) * 100) + int(50 / total_steps)
                except (ValueError, ZeroDivisionError):
                    progress = 10  # fallback
            else:
                progress = 0

            # Accumulate overall progress
            total_progress += progress / 6

            # Phase indicator
            if is_complete:
                indicator = "✓"
                color = GREEN
            elif is_current:
                indicator = "►"
                color = YELLOW | curses.A_BOLD
            else:
                indicator = "○"
                color = WHITE

            self.safe_addstr(stdscr, y, 2, indicator, color)
            self.safe_addstr(stdscr, y, 4, f"{phase_num}.", color)
            self.safe_addstr(stdscr, y, 7, phase_info['name'], color)

            # Progress bar for each phase
            self.safe_addstr(stdscr, y, 18, "[")
            self.draw_progress_bar(stdscr, y, 19, bar_width, progress, GREEN if is_complete else YELLOW)
            self.safe_addstr(stdscr, y, 19 + bar_width, "]")
            self.safe_addstr(stdscr, y, 21 + bar_width, f"{progress:3d}%")
            y += 1

        y += 1

        # Overall Progress
        self.safe_addstr(stdscr, y, 0, "─" * (width - 1))
        y += 1
        self.safe_addstr(stdscr, y, 2, "OVERALL", curses.A_BOLD)
        overall_bar_width = min(40, width - 20)
        overall_progress = int(total_progress)
        if status == 'completed':
            overall_progress = 100
        self.safe_addstr(stdscr, y, 12, "[")
        self.draw_progress_bar(stdscr, y, 13, overall_bar_width, overall_progress, GREEN)
        self.safe_addstr(stdscr, y, 13 + overall_bar_width, f"] {overall_progress:3d}%")
        y += 2

        # Current Step Section
        self.safe_addstr(stdscr, y, 0, "─" * (width - 1))
        y += 1
        self.safe_addstr(stdscr, y, 2, "CURRENT", curses.A_BOLD)
        y += 1

        if status == 'completed':
            self.safe_addstr(stdscr, y, 4, "All phases completed", GREEN)
        else:
            phase_info = PHASES.get(current_phase, {'name': 'Unknown', 'desc': 'Unknown'})
            self.safe_addstr(stdscr, y, 4, f"► Phase {current_phase}: {phase_info['desc']} - Step {current_step}", YELLOW)
        y += 2

        # Stats Section
        self.safe_addstr(stdscr, y, 0, "─" * (width - 1))
        y += 1
        self.safe_addstr(stdscr, y, 2, "STATS", curses.A_BOLD)
        y += 1

        self.safe_addstr(stdscr, y, 4, f"Files: ")
        self.safe_addstr(stdscr, y, 11, str(files_count), GREEN)
        self.safe_addstr(stdscr, y, 11 + len(str(files_count)), " created")

        self.safe_addstr(stdscr, y, 30, f"Lines: ")
        self.safe_addstr(stdscr, y, 37, str(lines_count), GREEN)
        y += 2

        # Agents Section
        self.safe_addstr(stdscr, y, 0, "─" * (width - 1))
        y += 1
        self.safe_addstr(stdscr, y, 2, "AGENTS", curses.A_BOLD)
        y += 1

        agents = data.get('agents', [])
        if agents:
            running = [a for a in agents if a.get('status') == 'running']
            completed = [a for a in agents if a.get('status') == 'completed']

            for agent in running[:2]:
                self.safe_addstr(stdscr, y, 4, f"► {agent['name']}", GREEN | curses.A_BOLD)
                y += 1
            for agent in completed[-2:]:
                self.safe_addstr(stdscr, y, 4, f"✓ {agent['name']}")
                y += 1
        else:
            self.safe_addstr(stdscr, y, 4, "No agents tracked yet")
            y += 1

        y += 1

        # Footer
        self.safe_addstr(stdscr, y, 0, "═" * (width - 1), CYAN)

        return y

    def render_footer(self, stdscr, width, height):
        """Render common footer with copy command and keyboard shortcuts"""
        WHITE = curses.color_pair(5)
        CYAN = curses.color_pair(1)

        # Get script path for copy command
        script_path = Path(__file__).resolve()
        session_path_str = str(self.session_path)

        # Footer line 1: Copy command
        footer_y = height - 3
        copy_cmd = f"python3 {script_path} {session_path_str}"
        max_cmd_len = width - 25
        if len(copy_cmd) > max_cmd_len:
            copy_cmd = f"python3 .../{script_path.name} .../{self.session_path.name}"

        self.safe_addstr(stdscr, footer_y, 2, "Open in another terminal:", CYAN)
        self.safe_addstr(stdscr, footer_y + 1, 4, copy_cmd, WHITE)

        # Footer line 2: Keyboard shortcuts
        shortcuts = "q: Quit  |  r: Return to Claude terminal"
        self.safe_addstr(stdscr, height - 1, 2, shortcuts)

    def return_to_parent_terminal(self):
        """Return focus to the parent terminal where Claude is running (macOS only)"""
        meta = self.read_json(self.meta_file)
        parent_info = meta.get('parentTerminal', {})

        if not parent_info:
            return False

        os_type = parent_info.get('os', '')
        window_id = parent_info.get('windowId', '')

        if os_type == 'Darwin' and window_id:
            try:
                # Use AppleScript to activate Terminal window
                script = f'''
                    tell application "Terminal"
                        activate
                        set index of window id {window_id} to 1
                    end tell
                '''
                subprocess.run(['osascript', '-e', script], capture_output=True)
                return True
            except Exception:
                pass

        # Fallback: try to activate Terminal app
        if os_type == 'Darwin':
            try:
                tty = parent_info.get('tty', '')
                # Just activate Terminal app
                subprocess.run(['osascript', '-e', 'tell application "Terminal" to activate'], capture_output=True)
                return True
            except Exception:
                pass

        return False

    def render(self, stdscr):
        curses.start_color()
        curses.use_default_colors()
        curses.init_pair(1, curses.COLOR_CYAN, -1)
        curses.init_pair(2, curses.COLOR_GREEN, -1)
        curses.init_pair(3, curses.COLOR_YELLOW, -1)
        curses.init_pair(4, curses.COLOR_RED, -1)
        curses.init_pair(5, curses.COLOR_WHITE, -1)
        curses.init_pair(6, curses.COLOR_BLACK, curses.COLOR_YELLOW)

        curses.curs_set(0)
        stdscr.timeout(1000)

        while True:
            try:
                stdscr.clear()
                height, width = stdscr.getmaxyx()

                data = self.get_status()

                if not data:
                    self.safe_addstr(stdscr, 1, 2, "Waiting for session...", curses.color_pair(3))
                    self.safe_addstr(stdscr, 2, 2, f"Path: {self.session_path}")
                    self.safe_addstr(stdscr, height - 1, 2, "Press 'q' to quit")
                    stdscr.refresh()
                    if stdscr.getch() == ord('q'):
                        break
                    continue

                mode = self.detect_mode(data)
                waiting = data.get('waitingForUser', False)
                waiting_msg = data.get('waitingMessage', 'Waiting for user input')

                # Render based on mode
                if mode == 'execute':
                    self.render_execute(stdscr, data, width, height)
                else:
                    self.render_spec_it(stdscr, data, width, height)

                # Common footer
                self.render_footer(stdscr, width, height)

                # Overlay for user input
                if waiting:
                    self.draw_overlay(stdscr, height, width, waiting_msg)

                stdscr.refresh()

                key = stdscr.getch()
                if key == ord('q'):
                    break
                elif key == ord('r'):
                    if self.return_to_parent_terminal():
                        # Successfully switched, continue running dashboard
                        pass

            except KeyboardInterrupt:
                break
            except Exception as e:
                self.safe_addstr(stdscr, 0, 0, f"Error: {str(e)}")
                stdscr.refresh()
                if stdscr.getch() == ord('q'):
                    break


def find_session(start_path: str = ".") -> str:
    for pattern in ["tmp/*/_status.json", "**/tmp/*/_status.json", ".spec-it/execute/*/_state.json"]:
        for f in Path(start_path).glob(pattern):
            return str(f.parent)
    return ""


def main():
    if len(sys.argv) > 1:
        session_path = sys.argv[1]
    else:
        session_path = find_session()
        if not session_path:
            print("Usage: python3 dashboard.py <session_path>")
            sys.exit(1)

    if not Path(session_path).exists():
        print(f"Session path not found: {session_path}")
        sys.exit(1)

    dashboard = Dashboard(session_path)
    curses.wrapper(dashboard.render)


if __name__ == "__main__":
    main()
