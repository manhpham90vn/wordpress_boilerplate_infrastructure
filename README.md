# Wordpress boilerplate infrastructure
- [x] cache with redis
- [x] cdn with cloudfront over s3
- [x] support https
- [x] auto deploy infrastructure to aws with terraform (100%)
- [x] latest aim (Amazon Linux 2023 on Amazon EC2)

## EC2
- [x] automatic install nginx, php-fpm, mariadb, redis
- [x] all in one in single ec2 instance (nginx, php-fpm, mariadb, redis)
- [ ] auto backup database to s3
- [ ] health check with route 53, sns, lambda

## EC2_ELB_RDS
- [x] automatic install nginx, php-fpm, redis
- [x] load balancer and auto scaling
- [x] database with rds
- [ ] auto backup database (snapshot) to s3
- [ ] use efs with auto scaling
- [x] fix access wp-admin [link](https://wordpress.stackexchange.com/questions/250240/setting-serverhttps-on-prevents-access-to-wp-admin)

## ECS

## EKS
