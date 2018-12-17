# Docker - Google Apps Manager (GAM)

[GAM](https://github.com/jay0lee/GAM) is a command line tool for Google Apps administrators to manage domain and user settings


* Visit the [Wiki pages](https://github.com/jay0lee/GAM/wiki) for instructions and examples

---


### Clone the repository:

```
git clone {this-repo}
```

### Prepare Credentials First

*For credential creation, look at the [detailed instruction page](https://github.com/jay0lee/GAM/wiki/CreatingClientSecretsFile) on how to create them.*

NOTE: When you get to the stage of needing to input the scope string into the Google Admin Console, use this string below instead of the one provided in the setup guide (that one doesn't have the group settings and other api scopes enabled).

```
https://apps-apis.google.com/a/feeds/emailsettings/2.0/,https://mail.google.com/,https://sites.google.com/feeds,https://www.google.com/m8/feeds,https://www.googleapis.com/auth/activity,https://www.googleapis.com/auth/admin.directory.group,https://www.googleapis.com/auth/admin.directory.group.member,https://www.googleapis.com/auth/admin.directory.group.readonly,https://www.googleapis.com/auth/admin.directory.user,https://www.googleapis.com/auth/admin.directory.user.security,https://www.googleapis.com/auth/admin.reports.audit.readonly,https://www.googleapis.com/auth/admin.reports.usage.readonly,https://www.googleapis.com/auth/apps.groups.settings,https://www.googleapis.com/auth/calendar,https://www.googleapis.com/auth/drive,https://www.googleapis.com/auth/drive.file,https://www.googleapis.com/auth/drive.metadata.readonly,https://www.googleapis.com/auth/gmail.modify,https://www.googleapis.com/auth/gmail.readonly,https://www.googleapis.com/auth/gmail.settings.basic,https://www.googleapis.com/auth/gmail.settings.sharing,https://www.googleapis.com/auth/plus.login,https://www.googleapis.com/auth/plus.me,https://www.googleapis.com/auth/userinfo.email,https://www.googleapis.com/auth/userinfo.profile 

```

Once you have these files, copy them into the appropriate environment directory
Inside of {this-repo}/environments/dev/auth/ you should have:

- `oauth2.txt`
- `oauth2service.json`
- `client_secrets.json`

NOTE: On first install, you may need to create an empty "oauth2.txt" file. Do that using the command below (replacing "dev" with whatever environment folder you're using). Otherwise, it will try to create a folder called oauth2.txt and cause problems.

```
touch environments/dev/auth/oauth2.txt
```

###### Next, .bashrc setup
Copy the bash-sample file to make a .bashrc file, that will be copied into the container upon build/run.
```
cp bash/sample.bashrc bash/.bashrc
```
Then make any edits to it that you'd like. Like, maybe you need to add a proxy alias or something if you're running GAM behind a proxy.


### Build the docker image

Build an image using the Dockerfile from the repo. This will create an image called "img-gam" upon which you'll run/start all the containers with GAM for each domain/environment. IE: One image, multiple containers.

```
make build-image
```

### Run Instance of Container using environment creds

Assuming you have the credentials files in the right places, you should be able to run GAM now.

```
// Change {ENV} to your domain if you're running multiple
// instances of GAM for different Google domains.
// Case sensitive 
 
make run-instance ENV=dev
or
make run-intance ENV=prod

```
(This will pass the "dev" variable into the path for where to look for your credentials files, and also which directory to mount when you need to use csv files for batch processing etc).


You can therefore have multiple instances of GAM for different domains if you'd like:

```
// This will look for credentials files in:
// {this-repo}/environments/mydomain.edu/auth)
 
make run-instance ENV=mydomain.edu

```

After the "make run" command, you will be at a bash prompt, where you can use any GAM command. On first run it will prompt you to authorize the scopes, and visit the URL as the super admin. Just follow the on-screen prompts after running the initial gam command. Subsequent calls to GAM should work without authorization, because it's storing/using the information in the 3 files stored in the environments/.../auth folder.

```
gam info domain
gam whatis user@mydomain.com
```

# Upgrading GAM #

When you need to upgrade GAM, just remove the docker image, and rebuild. IE: 

```
docker rmi img-gam
make build-image
make run-instance ENV=dev
```

# Troubleshooting #

If the container throws errors (like a container by this name already exists/is running), you may need to remove the container/image, and then run the "make run-instance" command again from above.
