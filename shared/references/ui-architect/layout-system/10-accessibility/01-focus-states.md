# Focus States

포커스 상태 스타일링.

## Focus Ring

모든 인터랙티브 요소는 visible focus를 가져야 함.

```css
.focus-ring {
  outline: none;
  ring: 2px;
  ring-color: theme('colors.blue.400');
  ring-offset: 2px;
}
```

## Tailwind Classes

```tsx
<button className="
  focus:outline-none
  focus:ring-2 focus:ring-blue-400 focus:ring-offset-2
">
  Button
</button>

<input className="
  focus:outline-none
  focus:ring-2 focus:ring-blue-400
  focus:border-transparent
" />

<a className="
  focus:outline-none
  focus:ring-2 focus:ring-blue-400 focus:ring-offset-2
  rounded
">
  Link
</a>
```

## Focus-Visible

마우스 클릭 시 포커스 링 숨기기 (키보드 탐색 시에만 표시):

```tsx
<button className="
  focus:outline-none
  focus-visible:ring-2 focus-visible:ring-blue-400 focus-visible:ring-offset-2
">
  Button
</button>
```

## Focus Within

자식 요소에 포커스가 있을 때 부모 스타일링:

```tsx
<div className="
  focus-within:ring-2 focus-within:ring-blue-400
  p-4 rounded-lg
">
  <input type="text" />
</div>
```

## YAML Reference

```yaml
accessibility:
  focus:
    ring:
      width: "2px"
      color: "blue-400"
      offset: "2px"
    classes:
      button: "focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2"
      input: "focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent"
      link: "focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2 rounded"
```

## Testing Checklist

- [ ] Tab through all interactive elements
- [ ] Focus ring is clearly visible
- [ ] Focus order is logical
- [ ] No focus trap (unless modal)
