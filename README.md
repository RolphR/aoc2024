# Why?

Because I (apparently) can...

## But Really, WHY?

I though it would be difficult and fun.

## Log of encountered WTFs

### Capture groups in `regexall`

Capture groups didn't behave like I expected:

```
> regexall("(wtf)+","wtfwtf")
tolist([
  [
    "wtf",
  ],
])
> regexall("(?:wtf)+","wtfwtf")
tolist([
  "wtfwtf",
])
```

The solution was a non-capturing group indicator `?:`

### Strings are numbers, unless you put them in a collection

Terraform (go-cty) is quite lenient when it comes to dynamic types, unless it's in a ~~list~~ tuple or set, then it's not...

```
> max("12","23")
23
> max(["12","23"])
╷
│ Error: Invalid function argument
│
│   on <console-input> line 1:
│   (source code not available)
│
│ Invalid value for "numbers" parameter: number required.
╵
```

The solution? Abuse my [favorite operator](https://developer.hashicorp.com/terraform/language/expressions/function-calls#expanding-function-arguments) (which is not an actual operator):

```
> max(["12","23"]...)
23
```
