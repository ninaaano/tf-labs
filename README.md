# Terraform labs
테라폼 실습을 위한 레파지토리 입니다  
학습 목적을 위해 사이트를 참고하여 개인 환경에 맞게 변경하여 사용했습니다.

```
terraform init
terraform plan
terraform apply
```

실습 후엔 꼭!!! 지워야합니다!!
```
terraform destroy
```


## 2-Tier Architecture
- 모듈 사용

```
|   main.tf
|   output.tf
|   provider.tf
|   terraform.tfstate
|   terraform.tfstate.backup
|   terraform.tfvars
|   variables.tf
|   
+---.terraform
|   +---modules
|   |       modules.json
|                               
\---modules
    +---alb-tg
    |       gather.tf
    |       main.tf
    |       variables.tf
    |       
    +---aws-autoscaling
    |       deploy.sh
    |       gather.tf
    |       main.tf
    |       variable.tf
    |       
    +---aws-iam
    |       iam-instance-profile.tf
    |       iam-policy.json
    |       iam-policy.tf
    |       iam-role.json
    |       iam-role.tf
    |       variables.tf
    |       
    +---aws-rds
    |       gather.tf
    |       main.tf
    |       variables.tf
    |       
    +---aws-vpc
    |       main.tf
    |       variables.tf
    |       
    +---aws-waf-cdn-acm-route53
    |       acm.tf
    |       cdn.tf
    |       gather.tf
    |       route53.tf
    |       variables.tf
    |       waf.tf
    |       
    \---security-group
            gather.tf
            main.tf
            variable.tf
            
```

### Directory Overview
- Root
    - main.tf: 배포를 조정하는 기본 Terraform 구성입니다.

    - variables.tf: 기본 Terraform 구성에 사용되는 변수의 정의입니다.

    - variables.tfvars: 정의된 변수에 대한 값을 입력합니다.

- modules:
    - alb-tg:
        - gather.tf: ALB(Application Load Balancer) 및 TG(대상 그룹)에 대한 정보를 수집하는 Terraform 스크립트입니다.
        - main.tf: ALB 및 TG에 대한 기본 Terraform 구성입니다.
        - variables.tf: ALB 및 TG 모듈에 사용되는 변수를 정의합니다.
    - aws-autoscaling:
        - deploy.sh: Auto Scaling 그룹 배포를 위한 셸 스크립트입니다.
        - gather.tf: Auto Scaling 그룹에 대한 정보를 수집하는 Terraform 스크립트입니다.
        - main.tf: Auto Scaling 그룹의 기본 Terraform 구성입니다.
        - variable.tf: Auto Scaling Group 모듈에서 사용되는 변수에 대한 정의입니다.
    - aws-iam:
        - iam-instance-profile.tf: IAM 인스턴스 프로필의 Terraform 구성입니다.
        - iam-policy.json: IAM 정책이 포함된 JSON 파일입니다.
        - iam-policy.tf: IAM 정책에 대한 Terraform 구성입니다.
        - iam-role.json: IAM 역할이 포함된 JSON 파일입니다.
        - iam-role.tf: IAM 역할에 대한 Terraform 구성입니다.
        - variables.tf: IAM 모듈에서 사용되는 변수의 정의입니다.
    - aws-rds:
        - gather.tf: RDS 클러스터에 대한 정보를 수집하는 Terraform 스크립트입니다.
        - main.tf: RDS 클러스터의 기본 Terraform 구성입니다.
        - variables.tf: RDS 모듈에 사용되는 변수의 정의입니다.
    - aws-vpc:
        - main.tf: Virtual Private Cloud(VPC) 및 퍼블릭/프라이빗 서브넷, ElasticIP 등과 같은 기타 네트워킹 서비스에 대한 기본 Terraform 구성입니다.
        - variables.tf: VPC 모듈에서 사용되는 변수의 정의입니다.
    - aws-waf-cdn-acm-route53:
        - acm.tf: ACM(Amazon Certificate Manager)용 Terraform 구성입니다.
        - cdn.tf: CDN(Content Delivery Network)을 위한 Terraform 구성입니다.
        - gather.tf: WAF, CDN, ACM 및 Route 53에 대한 정보를 수집하는 Terraform 스크립트입니다.
        - route53.tf: Route 53에 대한 Terraform 구성.
        - variables.tf: WAF, CDN, ACM 및 Route 53 모듈에 사용되는 변수를 정의합니다.
        - waf.tf: AWS WAF(웹 애플리케이션 방화벽)를 위한 Terraform 구성입니다.
    - security-group:
        - gather.tf: 보안 그룹에 대한 정보를 수집하는 Terraform 스크립트입니다.
        - main.tf: 보안 그룹에 대한 기본 Terraform 구성입니다.
        - variable.tf: 보안 그룹 모듈에서 사용되는 변수의 정의입니다.

![제목 없는 다이어그램](https://github.com/ninaaano/tf-labs/assets/95615105/09efbf7a-5aa0-469c-a774-3ce76d5d9904)

## Output
![image](https://github.com/ninaaano/tf-labs/assets/95615105/fb1c824c-8b32-4fdc-8518-14fac57bb380)

## 3-Tier Architecture
- 각 환경을 파일로 분리하여 사용

```
|   alb.tf
|   instance.tf
|   main.tf
|   policies.tf
|   provider.tf
|   roles.tf
|   securitygroups.tf
|   subnets.tf
|   terraform.tfstate
|   terraform.tfstate.backup
|   terraform.tfvars
|   userdata.sh
|   variables.tf
|   
+---.terraform
|   \---providers
|                               
\---json-policies
        nino-ec2-admin.json
        nino-ssm-user.json
        
```

![terraform 구성도-페이지-1](https://github.com/ninaaano/tf-labs/assets/95615105/3e2d7aaa-66a8-4210-b834-d65a40d479be)


### Reference
https://blog.devops.dev/deploy-two-tier-architecture-on-aws-using-terraform-9a1e310811c0

https://github.com/Sherbertdlc/Terraform-Multi-Tier-AWS-Project/tree/main