# Scripts

## [git-related](git-related/)
- [loglive](git-related/loglive) - Live git log

## [video-editing](video-editing/)
- [vid](video-editing/vid) - Video editing script that uses the following commands:
  - [trim](video-editing/trim): Trim video either from the start to specified time or from specified time to the end or from specified time to specified time
  - [split](video-editing/split-video): Split video into audio-only and video-only files
  - [merge](video-editing/merge): Merge all videos with (.mp4) extension in the current directory into one video
  - [join](video-editing/join): Join video-only and audio-only files into one video
  - [volume](video-editing/volume): Change volume of video

## [testing](testing/)

for OSC summer training '23 [The-Art-of-Linux](https://github.com/Open-Source-Community/The-Art-of-Linux-23) with ASU FCIS students where asked to write scripts at [session 4](https://github.com/Open-Source-Community/The-Art-of-Linux-23/tree/master/Session4).

To showcase the power of scripting i wrote a script to test the scripts written by the students.

- [auto-test](testing/auto-test.sh) : main script, takes input a csv file containing: 

| name | email | ASU FUCIS ID | github-repo-link |
| ---- | ----- | ------------ | ---------------- |

clones each repo, pause for manual fixes if the student didn't deliver the script in the required format, then runs each script with its aproperiate test cases and prints the results in a csv file.

- [test_syntax](testing/test_syntax.sh): run the script to make sure it doesn't fail on syntax errors, if failed it opens vim to edit the script to fix the syntax error, and run it again.

| script                                           | objective                                                                        | test                                              |
| ------------------------------------------------ | -------------------------------------------------------------------------------- | ------------------------------------------------- |
| [system_info](testing/solution/system_info.sh)   | prints username and kernel version                                               | [test_system_info](testing/test_system_info.sh)   |
| [file_check](testing/solution/file_check.sh)     | check if file exists in a given directory or not and prints its content if found | [test_file_check](testing/test_file_check.sh)     |
| [rename_files](testing/solution/rename_files.sh) | rename all files in a given directory with a given extension and new name        | [test_rename_files](testing/test_rename_files.sh) |
| [calculator](testing/solution/calculator.sh)     | simple calculator                                                                | **manual testing**                                |
