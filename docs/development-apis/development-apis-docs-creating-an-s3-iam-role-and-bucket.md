---
title: 'How to create an AWS IAM user and S3 bucket'
description: 'How to create an AWS IAM user and S3 bucket.'
keywords: ['AWS', 'IAM', 'S3 bucket']
slug: /integrations/s3/creating-iam-user-and-s3-bucket
sidebarTitle: 'How to create an AWS IAM user and S3 bucket'
doc_type: 'guide'
---

import { Image } from "/snippets/components/Image.jsx";

> This guide shows you how you can set up an IAM user and S3 bucket in AWS,
> a prerequisite step for taking backups to S3 or configuring ClickHouse to
> store data on S3

## Create an AWS IAM user {#create-an-aws-iam-user}

In this procedure, we'll be creating a service account user, not a login user.

1.  Log into the AWS IAM Management Console.

2. In the `Users` tab, select `Create user`

3. Enter a user-name

4. Select `Next`

5. Select `Next`

6. Select `Create user`

The user is now created.
Click on the newly created user

7. Select `Create access key`

8. Select `Application running outside AWS`

9. Select `Create access key`

10. Download your access key and secret as a .csv for use later

## Create an S3 bucket {#create-an-s3-bucket}

1. In the S3 bucket section, select **Create bucket**

2. Enter a bucket name, leave other options default

3. Leave `Block all Public Access` enabled; public access isn't needed.

4. Select **Create Bucket** at the bottom of the page

5. Select the link, copy the ARN, and save it for use when configuring the access policy for the bucket

6. Once the bucket has been created, find the new S3 bucket in the S3 buckets list and select the bucket name which will take you to the page shown below:

7. Select `Create folder`

8. Enter a folder name that will be the target for the ClickHouse S3 disk or backup and select `Create folder` at the bottom of the page

9. The folder should now be visible on the bucket list

10. Select the checkbox for the new folder and click on `Copy URL`. Save the URL for use in the ClickHouse storage configuration in the next section.

11. Select the **Permissions** tab and click on the **Edit** button in the **Bucket Policy** section

12. Add a bucket policy, example below

```json
{
    "Version": "2012-10-17",
    "Id": "Policy123456",
    "Statement": [
        {
            "Sid": "abc123",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::782985192762:user/docs-s3-user"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::ch-docs-s3-bucket",
                "arn:aws:s3:::ch-docs-s3-bucket/*"
            ]
        }
    ]
}
```

|Parameter | Description | Example Value |
|----------|-------------|----------------|
|Version | Version of the policy interpreter, leave as-is | 2012-10-17 |
|Sid | User-defined policy id | abc123 |
|Effect | Whether user requests will be allowed or denied | Allow |
|Principal | The accounts or user that will be allowed | arn:aws:iam::782985192762:user/docs-s3-user |
|Action | What operations are allowed on the bucket| s3:*|
|Resource | Which resources in the bucket will operations be allowed in | "arn:aws:s3:::ch-docs-s3-bucket", "arn:aws:s3:::ch-docs-s3-bucket/*" |

13. Save the policy configuration
