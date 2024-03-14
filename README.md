# Wordpress boilerplate infrastructure
- cache with redis
- cdn with cloudfront over s3
- support https
- auto deploy infrastructure to aws with terraform (100%)
- latest aim (Amazon Linux 2023 on Amazon EC2)

## EC2
- automatic install nginx, php-fpm, mariadb, redis
- all in one in single ec2 instance (nginx, php-fpm, mariadb, redis)
- auto backup database to s3 (todo)
- health check with route 53, sns, lambda (todo)

## EC2_ELB_RDS
- automatic install nginx, php-fpm, redis
- load balancer and auto scaling
- database with rds
- auto backup database (snapshot) to s3 (todo)

## ECS

## EKS
