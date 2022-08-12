Notes for when manipulating or working with website that don't use the default baseurl

1. `base` tag in the html `head` like the following

```html
<head>
  <base href="/" target="_self" />
</head>
```

[More about it](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/base)

2. To respect the base tag, you can use the following in your markdown or html files

For markdown, use relative paths

```markdown
[link](dir/file)
```

For html, the same can be done and most browsers will handle it for you

```html
<a href="dir/file"> File </a>
```

3. To get the browser to go the root of the baseurl even when the `head` doesn't have a
   `base` tag.

```html
<a href="."> Root </a>
```
