# §PROJECT_NAME§ - Readme

All setup.
Start coding in src/

# Infrastructure:

## Shell scripts (/opt)
### bootstrap.sh
**Runs at every Boot of the container**

Run additional scripts when your container boots up
This file may be used to execute additional scripts for your container

### build.sh
**Runs while the image is being built AND at the FIRST BOOT of your DEVELOPMENT container**

Add additional dependencies.
This file is meant to install additional dependencies to your images which are not already installed
in our base images (LDAP, redis...)

_NOTE: When the script runs in the development container it is only executed the first time your container boots
it will NOT be executed on subsequent boots. So use "development" for scripts that have to be called every time
you start your development environment._

### development.sh
**Runs at every Boot of the DEVELOPMENT container**

Run scripts for your development environment.
Executed when the development container boots up. Can be used to simulate additional build steps
you would normally put into "build.sh" but don't need for your production container

### directories.sh
**Runs while the image is being built AND at every Boot of the container**

Create required directories
Allows you to create additional required directories for your project.
BEWARE: This file might run multiple times in a single boot sequence (mostly when building the container or when
booting the development environment). So make sure you keep that in mind!

You should use the ensure_dir function to create new directories whenever possible.
It works identical to mkdir -p $YOUR_DIR but it also sets the directory permissions
for every created directory in the path to the $DEFAULT_PERMISSIONS

### permissions.sh
**Runs while the image is being built AND at every Boot of the container**

Set directory permissions to your needs.
The file is executed on build, boot and after composer tasks in your development environment
You should use ensure_perms whenever possible it will set both file and folder permissions
to the $DEFAULT_PERMISSIONS as well as the owner to the $DEFAULT_OWNER.

- Directories are automatically handled recursively
- You can pass a custom mode as second parameter

_NOTE: When ensure_perms sets the permissions for a directory it will automatically touch a "perms.set",
each directory that has such a marker file will not be updated by ensure_perms.
This is used, because permission updates are remarkably slow and with the marker we can even
call this function on a mounted directory to ensure the permissions are set correctly without worring about
the boot-up time for subsequent deployments_

## Bash functions
### ensure_dir
Simple helper to make sure a given directory exists. If it not exists it will create it recursively
It will also call setPerms() on the directory if you pass additional permissions
as a second parameter. The directory will be created as the www-data user

- @param $directory The path to the directory to create if it does not exist
- @param $permissions By default "u=rwX,g=rwX,o-rwx" but can be set to any other permission value

### ensure_perms
Helper to make sure a directory has the correct permissions, recursively.
BUT it will assume that between runs the permissions will not change
therefore it writes a marker file into the directory to check if it already
processed the file or not.

This is used for volume mounts in your production environment.
You can call this function on a mounted directory to ensure the permissions are set correctly
Every subsequent boot will not update the permissions again as long as the marker file exists
Accepts 2 parameters

- @param $directory The path to the directory to set the permissions for
- @param $permissions By default "u=rwX,g=rwX,o-rwx" but can be set to any other permission value

### set_permissions
Helper to call the /opt/permissions.sh file if it exists

## Bash functions (DEV ONLY)
### composer
Global executable to run composer tasks. Look [here](https://getcomposer.org/doc/01-basic-usage.md) for additional information.

### c
Alias for "composer" but will not kill your console when the script fails -> You should only use this
manually in a development environment