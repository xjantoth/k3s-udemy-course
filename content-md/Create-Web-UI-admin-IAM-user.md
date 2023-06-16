### Create terraform IAM user

Create a new IAM user with MFA and `AdministrationAccess` privileges.
Log in as `Root user` user with your email address and root password.

![Create terraform IAM usr](../img/tf-user-1.png)

Open up a mobile app and type in 6-digit code.

![Create terraform IAM usr](../img/tf-user-2.png)

Navigate to IAM and click at `Users`` section. Click `Add users` button.

![Create terraform IAM usr](../img/tf-user-3.png)

Choose a username e.g. `k3s-admin`

![Create terraform IAM usr](../img/tf-user-4.png)

Through `Security Credentials` tab choose `Attach policies directly` and pick `AdministrationAccess`

![Create terraform IAM usr](../img/tf-user-5.png)

Create user.

![Create terraform IAM usr](../img/tf-user-6.png)

Through `Security Credentials` tab choose `MFA` settings.

![Create terraform IAM usr](../img/tf-user-7.png)

Scan bar code and type in 6-digits numbers twice in a row.

![Create terraform IAM usr](../img/tf-user-8.png)

Through `Security Credentials` tab choose `Enable console access` settings.

![Create terraform IAM usr](../img/tf-user-9.png)

Setup password.

![Create terraform IAM usr](../img/tf-user-10.png)

User created. Save password and login URL safely and never share with anyone.

![Create terraform IAM usr](../img/tf-user-11.png)
