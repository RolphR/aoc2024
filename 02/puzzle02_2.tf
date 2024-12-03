locals {
  puzzle2_dampened_reports = [
    for report in local.puzzle1_reports :
    concat(
      [
        report
      ],
      [
        for i in range(0, length(report)) :
        flatten([
          slice(report, 0, i),
          slice(report, i + 1, length(report))
        ])
      ]
    )
  ]
  puzzle2_dampened_level_changes = [
    for reports in local.puzzle2_dampened_reports :
    [
      for report in reports :
      [
        for i in range(0, length(report) - 1) :
        element(report, (i)) - element(report, i + 1)
      ]
    ]
  ]

  puzzle2_solution = length([
    for reports in local.puzzle2_dampened_level_changes :
    reports
    if anytrue([
      for changes in reports :
      anytrue([
        alltrue([for c in changes : -3 <= c && c <= -1]),
        alltrue([for c in changes : 1 <= c && c <= 3]),
      ])
    ])
  ])
}

output "puzzle2" {
  value = local.puzzle2_solution
  precondition {
    condition     = local.puzzle2_solution == 318
    error_message = "Invalid result"
  }
}
