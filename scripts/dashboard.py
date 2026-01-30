#!/usr/bin/env python3
"""
SPEC-IT Dashboard - Curses-based real-time monitoring
Usage: python3 dashboard.py [session_path]
"""

import curses
import json
import os
import sys
from datetime import datetime
from pathlib import Path


class Dashboard:
    def __init__(self, session_path: str):
        self.session_path = Path(session_path)
        self.status_file = self.session_path / "_status.json"
        self.meta_file = self.session_path / "_meta.json"

    def read_json(self, filepath: Path) -> dict:
        try:
            with open(filepath, 'r') as f:
                return json.load(f)
        except:
            return {}

    def get_status(self) -> dict:
        status = self.read_json(self.status_file)
        meta = self.read_json(self.meta_file)
        return {**meta, **status}

    def detect_mode(self, data: dict) -> tuple:
        if data.get('specSource') or data.get('qaAttempts') is not None:
            return 'execute', 5, 'SPEC-IT EXECUTE'
        if '.spec-it/execute' in str(self.session_path):
            return 'execute', 5, 'SPEC-IT EXECUTE'
        return 'spec-it', 6, 'SPEC-IT DASHBOARD'

    def get_phase_name(self, mode: str, phase: int) -> str:
        if mode == 'execute':
            names = {1: 'LOAD', 2: 'PLAN', 3: 'EXECUTE', 4: 'QA', 5: 'VALIDATE', 6: 'Complete'}
        else:
            names = {1: 'Design Brainstorming', 2: 'UI Architecture', 3: 'Critical Review',
                     4: 'Test Specification', 5: 'Final Assembly', 6: 'Complete'}
        return names.get(phase, 'Initializing')

    def calculate_progress(self, mode: str, data: dict) -> int:
        if mode == 'execute':
            completed = len(data.get('completedPhases', []))
            phase = data.get('currentPhase', 1)
            qa_attempts = data.get('qaAttempts', 0)
            progress = completed * 20
            if phase == 1: progress += 5
            elif phase == 2: progress += 10
            elif phase == 3: progress += 10
            elif phase == 4: progress += 5 + qa_attempts * 3
            elif phase == 5: progress += 10
            return min(progress, 100)

        # Spec-it mode
        folders = ['00-requirements', '01-chapters', '02-screens',
                   '03-components', '04-review', '05-tests', '06-final']
        weights = [10, 15, 25, 20, 15, 10, 5]
        progress = 0
        file_counts = []

        for folder in folders:
            folder_path = self.session_path / folder
            count = len(list(folder_path.glob('**/*.md'))) if folder_path.exists() else 0
            file_counts.append(count)

        is_fast_launch = file_counts[2] > 0 and file_counts[1] == 0

        if is_fast_launch:
            if file_counts[0] > 0: progress += 20
            if file_counts[2] > 0: progress += 10 + min(file_counts[2] * 4, 65)
            if file_counts[6] > 0: progress = 100
            return min(progress, 95) if file_counts[6] == 0 else 100
        else:
            for i, count in enumerate(file_counts):
                if count > 0:
                    progress += weights[i]
            if file_counts[6] > 0:
                progress = 100
        return progress

    def count_files(self) -> tuple:
        total_files = 0
        total_lines = 0
        for md_file in self.session_path.glob('**/*.md'):
            if md_file.name.startswith('_'):
                continue
            total_files += 1
            try:
                total_lines += sum(1 for _ in open(md_file))
            except:
                pass
        return total_files, total_lines

    def format_duration(self, seconds: int) -> str:
        hours = seconds // 3600
        minutes = (seconds % 3600) // 60
        secs = seconds % 60
        return f"{hours:02d}:{minutes:02d}:{secs:02d}"

    def parse_iso_time(self, iso_str: str) -> datetime:
        try:
            if 'T' in iso_str:
                dt_part = iso_str.split('T')[0]
                time_part = iso_str.split('T')[1].split('+')[0].split('-')[0]
                return datetime.strptime(f"{dt_part} {time_part}", '%Y-%m-%d %H:%M:%S')
        except:
            pass
        return datetime.now()

    def safe_addstr(self, stdscr, y, x, text, attr=0):
        """Safely add string, avoiding curses errors"""
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

    def draw_progress_bar(self, stdscr, y, x, width, percent, color):
        """Draw progress bar safely with Unicode blocks"""
        bar_width = min(width - 7, 40)
        if bar_width <= 0:
            return
        filled = int(bar_width * percent / 100)
        empty = bar_width - filled

        self.safe_addstr(stdscr, y, x, "[")
        self.safe_addstr(stdscr, y, x + 1, "█" * filled, color)
        self.safe_addstr(stdscr, y, x + 1 + filled, "░" * empty)
        self.safe_addstr(stdscr, y, x + 1 + bar_width, f"] {percent:3d}%")

    def render(self, stdscr):
        # Initialize colors
        curses.start_color()
        curses.use_default_colors()
        curses.init_pair(1, curses.COLOR_CYAN, -1)    # CYAN
        curses.init_pair(2, curses.COLOR_GREEN, -1)   # GREEN
        curses.init_pair(3, curses.COLOR_YELLOW, -1)  # YELLOW
        curses.init_pair(4, curses.COLOR_RED, -1)     # RED
        curses.init_pair(5, curses.COLOR_WHITE, -1)   # WHITE

        curses.curs_set(0)
        stdscr.timeout(1000)

        while True:
            try:
                stdscr.clear()
                height, width = stdscr.getmaxyx()

                data = self.get_status()

                if not data:
                    self.safe_addstr(stdscr, 1, 2, "Waiting for spec-it session...", curses.color_pair(3))
                    self.safe_addstr(stdscr, 2, 2, f"Path: {self.session_path}")
                    self.safe_addstr(stdscr, height - 1, 2, "Press 'q' to quit")
                    stdscr.refresh()
                    if stdscr.getch() == ord('q'):
                        break
                    continue

                mode, total_phases, mode_label = self.detect_mode(data)

                session_id = data.get('sessionId', 'unknown')
                phase = data.get('currentPhase', 1)
                step = data.get('currentStep', '1.1')
                phase_name = self.get_phase_name(mode, phase)
                progress = self.calculate_progress(mode, data)

                start_time_str = data.get('startTime', data.get('lastCheckpoint', ''))
                if start_time_str:
                    start_time = self.parse_iso_time(start_time_str)
                    runtime = int((datetime.now() - start_time).total_seconds())
                else:
                    runtime = 0

                files_count, lines_count = self.count_files()

                y = 0

                # Check waiting state
                waiting = data.get('waitingForUser', False)
                waiting_msg = data.get('waitingMessage', 'Waiting for user input')

                if waiting:
                    self.safe_addstr(stdscr, y, 2, "!" * 50, curses.color_pair(3) | curses.A_BOLD)
                    y += 1
                    self.safe_addstr(stdscr, y, 2, "!  USER INPUT REQUIRED", curses.color_pair(3) | curses.A_BOLD)
                    y += 1
                    self.safe_addstr(stdscr, y, 2, f"!  {waiting_msg}", curses.color_pair(3))
                    y += 1
                    self.safe_addstr(stdscr, y, 2, "!  Please respond in Claude Code terminal", curses.color_pair(3))
                    y += 1
                    self.safe_addstr(stdscr, y, 2, "!" * 50, curses.color_pair(3) | curses.A_BOLD)
                    y += 2

                # Header
                header_color = curses.color_pair(2) if mode == 'execute' else curses.color_pair(1)
                self.safe_addstr(stdscr, y, 0, "=" * (width - 1))
                y += 1
                self.safe_addstr(stdscr, y, 2, mode_label, header_color | curses.A_BOLD)
                runtime_str = f"Runtime: {self.format_duration(runtime)}"
                self.safe_addstr(stdscr, y, width - len(runtime_str) - 3, runtime_str, curses.A_BOLD)
                y += 1
                self.safe_addstr(stdscr, y, 0, "=" * (width - 1))
                y += 2

                # Session info
                self.safe_addstr(stdscr, y, 2, f"Session: {session_id}")
                y += 2

                # Phase & Step
                self.safe_addstr(stdscr, y, 2, f"Phase: ", curses.A_BOLD)
                self.safe_addstr(stdscr, y, 9, f"{phase}/{total_phases}", curses.color_pair(5) | curses.A_BOLD)
                self.safe_addstr(stdscr, y, 14, f" - {phase_name}", curses.color_pair(1))
                y += 1

                self.safe_addstr(stdscr, y, 2, f"Step:  {step}")
                y += 2

                # Progress bar
                self.draw_progress_bar(stdscr, y, 2, width - 4, progress, curses.color_pair(2))
                y += 2

                # Agents section
                self.safe_addstr(stdscr, y, 0, "-" * (width - 1))
                y += 1
                self.safe_addstr(stdscr, y, 2, "AGENTS", curses.A_BOLD)
                y += 1

                agents = data.get('agents', [])
                if agents:
                    running = [a for a in agents if a.get('status') == 'running']
                    completed = [a for a in agents if a.get('status') == 'completed']
                    errors = [a for a in agents if a.get('status') == 'error']

                    summary = f"Total: {len(agents)}"
                    if running: summary += f"  [*] {len(running)} running"
                    if completed: summary += f"  [v] {len(completed)} done"
                    if errors: summary += f"  [x] {len(errors)} error"
                    self.safe_addstr(stdscr, y, 2, summary)
                    y += 1

                    for agent in running:
                        self.safe_addstr(stdscr, y, 4, f"> {agent['name']}", curses.color_pair(2) | curses.A_BOLD)
                        self.safe_addstr(stdscr, y, 30, "[running]", curses.color_pair(2))
                        y += 1

                    for agent in completed[-3:]:
                        duration = agent.get('duration', '-')
                        self.safe_addstr(stdscr, y, 4, f"v {agent['name']} ({duration})")
                        y += 1
                else:
                    self.safe_addstr(stdscr, y, 4, "No agents tracked yet")
                    y += 1

                y += 1

                # Stats section
                self.safe_addstr(stdscr, y, 0, "-" * (width - 1))
                y += 1
                self.safe_addstr(stdscr, y, 2, "STATS", curses.A_BOLD)
                y += 1

                self.safe_addstr(stdscr, y, 2, f"Files: ")
                self.safe_addstr(stdscr, y, 9, str(files_count), curses.color_pair(2))
                self.safe_addstr(stdscr, y, 9 + len(str(files_count)), " created")
                y += 1

                self.safe_addstr(stdscr, y, 2, f"Lines: ")
                self.safe_addstr(stdscr, y, 9, str(lines_count), curses.color_pair(2))
                self.safe_addstr(stdscr, y, 9 + len(str(lines_count)), " written")
                y += 1

                # Recent files
                recent_files = []
                try:
                    for md_file in sorted(self.session_path.glob('**/*.md'),
                                         key=lambda f: f.stat().st_mtime, reverse=True)[:3]:
                        if not md_file.name.startswith('_'):
                            recent_files.append(md_file.name)
                except:
                    pass

                if recent_files:
                    y += 1
                    self.safe_addstr(stdscr, y, 2, "Recent:")
                    y += 1
                    for fname in recent_files:
                        self.safe_addstr(stdscr, y, 4, f"+ {fname}")
                        y += 1

                # Footer
                self.safe_addstr(stdscr, y + 1, 0, "=" * (width - 1))
                self.safe_addstr(stdscr, height - 1, 2, "Press 'q' to quit")

                stdscr.refresh()

                key = stdscr.getch()
                if key == ord('q'):
                    break

            except KeyboardInterrupt:
                break
            except Exception as e:
                self.safe_addstr(stdscr, 0, 0, f"Error: {str(e)}")
                stdscr.refresh()
                if stdscr.getch() == ord('q'):
                    break


def find_session(start_path: str = ".") -> str:
    for pattern in ["tmp/*/_status.json", "**/tmp/*/_status.json"]:
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
