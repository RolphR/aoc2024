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

### Recursion is hard in terraform (day 06)

As Terraform is declerative, it wants to know the entire call graph before executing.
I have yet to find a way around the following errors using native/plain terraform:

```
✗ terraform plan
╷
│ Error: Cycle: module.move.output.finished (expand), module.move.output.debug (expand), module.move (close), module.move.local.target_location (expand), module.move.local.target_character (expand), module.move.local.map_move_forward (expand), module.move.local.guard_character (expand), module.move.local.turn_right_character (expand), module.move.local.guard_location (expand), module.move.local.map_turn_right (expand), module.move.local.new_map (expand), module.move.output.map (expand), terraform_data.step, module.move.var.map (expand), module.move.local.map_mark_visited (expand)
│
│
╵
```

and

```
➜  06 git:(main) ✗ terraform init
Initializing the backend...
Initializing modules...
- move.move in modules/move
- move.move.move in modules/move
- move.move.move.move in modules/move
- move.move.move.move.move in modules/move
- move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
- move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move in modules/move
╷
│ Error: Failed to remove local module cache
│
│ Terraform tried to remove
│ .terraform/modules/move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move
│ in order to reinstall this module, but encountered an error: unlinkat
│ .terraform/modules/move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move.move:
│ file name too long
╵
```

I did find a way to "cheat" with plain terraform by writing the step output to a statefile.
The next iteration obtains the step from the state via `jsondecode`, which is technically still not using providers and/or provider functions...

It does require a manual rerun until all steps are done (41 times for the dummy input)
This I have automated using bash/jq:

```
while $(terraform show --json | jq '.values.outputs.puzzle1_finished.value|not'); do terraform apply -auto-approve > /dev/null; done
```
