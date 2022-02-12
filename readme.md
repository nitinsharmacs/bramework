# BrameWork
Development framework for shell scripting.

## Available commands

1. brm run entry_file
2. brm build entry_file
3. brm deploy

### brm run <entry_file> [args...]
Entry file should be the main file which is entry point for all other utilities.
It'll create a single file of all sourced files and run it.

### brm build <entry_file>
It'll create an optamised single file in **build** directory in the project.

### brm deploy <bin_location>
1. It'll copy the builded file to specified bin location.
2. Set the executable permission





