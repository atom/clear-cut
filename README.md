# clear-cut

Calculate the specificity of a CSS selector

## Using

```sh
npm install clear-cut
```

```coffee
{specificity} = require 'clear-cut'
specificity('body') # 1
specificity('#footer') # 1000000
specificity('.error.message') # 2000
```
