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

Using the unfold technique is slow:

```
time terraform apply -auto-approve

Changes to Outputs:
  + puzzle1          = 4656
  + puzzle1_finished = true

You can apply this plan to save these new output values
to the Terraform state, without changing any real
infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

puzzle1 = 4656
puzzle1_finished = true
terraform apply -auto-approve  36005.15s user 61.87s system 144% cpu 6:56:03.19 total
```

### Not in range()

The range function can't generate more than 1024 elements:

```
> range(0,1024)
tolist([
  0,
  ...
  1023,
])
> range(0,1025)
╷
│ Error: Error in function call
│
│   on <console-input> line 1:
│   (source code not available)
│
│ Call to function "range" failed: more than 1024 values were generated; either decrease the difference between start
│ and end or use a smaller step.
╵

```

See [range Function](https://developer.hashicorp.com/terraform/language/functions/range):

```
Because the sequence is created as a physical list in memory, Terraform imposes an artificial limit of 1024 numbers in the resulting sequence in order to avoid unbounded memory usage if, for example, a very large value were accidentally passed as the limit or a very small value as the step. If the algorithm above would append the 1025th number to the sequence, the function immediately exits with an error.
```

### OOM

On day 7: it's nice to see OOM killer loves terraform:

```
[2940844.740856] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=user.slice,mems_allowed=0,global_oom,task_memcg=/user.slice/user-1000.slice/user@1000.service/app.slice/vte-spawn-f6c959c2-28db-436b-b16d-ddc2d44a98b8.scope,task=terraform,pid=6569,uid=1000
[2940844.740912] Out of memory: Killed process 6569 (terraform) total-vm:57699076kB, anon-rss:56331000kB, file-rss:2536kB, shmem-rss:0kB, UID:1000 pgtables:110660kB oom_score_adj:100
[2940847.609186] oom_reaper: reaped process 6569 (terraform), now anon-rss:0kB, file-rss:80kB, shmem-rss:0kB
```

Halving the problem space seemed to have addressed that.
Fun fact: terraform memory consumption peaked at 80% only to slowly decrease, until a result was given
