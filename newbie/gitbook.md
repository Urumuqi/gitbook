# gitbook config

## book.json

```json
{
    "plugins": [
        "-highlight",
        "-lunr",
        "-search",
        "-sharing",
        "prism",
        "prism-themes",
        "back-to-top-button",
        "chapter-fold",
        "expandable-chapters",
        "code",
        "splitter",
        "search-pro",
        "pageview-count",
        "tbfed-pagefooter",
        "github"
    ],
    "pluginsConfig": {
        "github": {
            "url": "https://github.com/Urumuqi/gitbook"
        },
        "tbfed-pagefooter": {
            "copyright": "Copyright &copy urumuqi@知世说 2020",
            "modify_label": "article last edit time : ",
            "modify_format": "YYYY-MM-DD HH:mm:ss"
        },
        "prism": {
            "css": [
              "prism-themes/themes/prism-material-oceanic.css"
            ]
        }
    }
}
```
