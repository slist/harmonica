# Shared by the "Compile all LilyPond scores" and "Compile gamme scores" steps
# in .github/workflows/compile-lilypond.yml. Meant to be sourced, not executed.
#
# Any line from a "% CI-IGNORE-BELOW" marker onward (and everything after it)
# is stripped before compilation, whatever its content (commented out or not).
# This protects against forgetting to comment out manual test lines left at
# the bottom of .ly files.
strip_ci_ignored() {
  local file="$1"
  local dir tmp_file
  dir=$(dirname "${file}")
  tmp_file=$(mktemp -p "${dir}" "ci-tmp.XXXXXX")
  mv "${tmp_file}" "${tmp_file}.ly"
  tmp_file="${tmp_file}.ly"
  awk '/^%[[:space:]]*CI-IGNORE-BELOW/{exit} {print}' "${file}" > "${tmp_file}"
  echo "${tmp_file}"
}
export -f strip_ci_ignored
