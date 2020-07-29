## Contributors :robot:
## <a href="https://www.github.com/vaibhav1929">Vaibhav Sorathiya</a>
## <a href="https://www.github.com/yash49">Yash shah</a>
## PSC project
## Semester : 4
## Division : D
### Roll No: 19BCE529 : https://github.com/vaibhav1929/pydrive-project
### Roll No:19BCE525 : https://github.com/yash49/pydrive-project

# pydrive-project
File storage &amp; sharing system (like google drive) built with Django (python).
Feature rich drive storage system to manage and backup your file in cloud. can upload any file in drive.
#### Sharing with other people 
share files and folders with other people with easy steps.
#### Vault
Hide your important and confidential files in vault. need password to open the vault.
#### Modern material design
Easily manage files with better and simple ui.


## Screenshots

### Login / SIgnup
![Screenshot (18)](https://user-images.githubusercontent.com/30389552/79065779-88e56c00-7cd0-11ea-90ec-95c9a39b5304.png)

### Dashboard
![Screenshot (17)](https://user-images.githubusercontent.com/30389552/79065790-a1558680-7cd0-11ea-8211-f1e652631b72.png)

### Upload Files
![Screenshot (20)](https://user-images.githubusercontent.com/30389552/79065842-0dd08580-7cd1-11ea-9232-ac7a2349a4f3.png)

### Vault
![Screenshot (19)](https://user-images.githubusercontent.com/30389552/79065849-1a54de00-7cd1-11ea-8e38-bddc42591348.png)


## Setup
### install Django
``` pip install Django ```

You need to install following libraries to make project work properly.

#### 1. pymysql
``` pip install pymysql ```

After installation,
Now go to following path in your computer:

C:\Users\ {Your-username-folder} \AppData\Local\Programs\Python\Python38-32\Lib\site-packages\pymysql\

Replace ```__init__.py``` file with uploaded ```pymysql\__init__.py``` file.(You can find new __init__.py file in pymysql folder)

#### 2.smtplib

#### 3.hashlib

#### 4.zipfile

### Database setup

Import given ```pydrive_db.sql``` file in PhPMyAdmin.(MySql Database)

Recommended to refer https://docs.djangoproject.com/en/3.0/topics/migrations/ if any error occurred.

Now setup is completed. follow the below link if any problem occurred.

####For testing purpose use following account:

1.email address: vaibhavpatel1921@gmail.com, password:12345678, vault password:1234

2.email address: yash49@gmail.com, password:12345678

https://docs.djangoproject.com/en/3.0/intro/tutorial01/

