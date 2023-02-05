# ECS Fargate Infrastructure with Terraform

일반적인 ECS Fargate 인프라 구성용 IaC Repository 입니다. <br/>
많은 기능을 제공 해주고 사용되는 테라폼을 사용하여 아래와 같은 인프라를 구성 하였습니다. <br />
Workspace 별로 나누어서 인프라를 관리 할 수 있기 때문에 환경별 인프라 배포 / 관리에도 용이합니다.<br />

## Infrastructures
크게 VPC, Public / Private Subnets 로 구성하며 Public Subnet 에는 Private Subnet에 요청 응답 서빙을 담당하는 서비스들이, Private Subnet 에는 각 인스턴스들(ECS, EKS, EB 와 같은..)을 배포 합니다.

![kemi-infra drawio (1)](https://user-images.githubusercontent.com/25698674/216813370-a03bfbd8-3f32-4071-8ee8-e5dcf9b87b00.png)

- Route 53
    - ACM
- VPC
    - Internet Gateway
    - Public Subnets
        - ALB
        - NAT  Gateway
    - Private Subnets
        - ECS Instances

## Prerequisites
- [Terraform CLI](https://developer.hashicorp.com/terraform/cli)
    ```bash
    $ brew install terraform
    ```
- [Route 53 도메인 Hosted zone](https://us-east-1.console.aws.amazon.com/route53/v2/hostedzones#) 생성

## Commands
배포 / 관리에 주로 사용되는 커맨드를 추려서 정리 하였습니다.

모든 명령어는 테라폼 프로젝트 경로에서 실행 되어야 합니다.
```bash
$ cd terraform/network
```

- 프로젝트 관리
    - terraform init - 초기 테라폼 프로젝트 초기화
    - terraform plan - apply 하여 배포 할 경우 어떤 변경점들이 있는지 확인하는 커맨드
        - --var-file 옵션으로 variable 변수에 들어갈 값들이 들어간 파일을 지정 할 수 있습니다
      ```bash
        $ terraform plan --var-file=dev.tfvars
      ```
    - terraform apply - 각 프로바이더에 배포
        - --var-file 옵션으로 variable 변수에 들어갈 값들이 들어간 파일을 지정 할 수 있습니다
      ```bash
        $ terraform apply --var-file=dev.tfvars
      ```
- 워크스페이스 관리
    - terraform workspace list - 워크스페이스 목록과 현재 선택되어 있는 워크스페이스 확인
    - terraform workspace select {workspace_name} - 워크스페이스 변경
        * workspace_name - 변경할 워크스페이스명
    - terraform workspace new {workspace_name} - 워크스페이스 생성
        * workspace_name - 생성할 워크스페이스명

### tfvars 파일 예시

환경별 인프라 관리 시 variables와 대치되는 환경별 변수 파일이 필요합니다(ex. dev.tfvars). <br />
access, secret key가 포함되기 때문에 repository 에는 배포되지 않고 따로 로컬에서 관리 되어야 합니다.

dev.tfvars
```terraform
access_key = "<your access_key>"
secret_key = "<your secret_key>"
account_id = "<your aws account id>"
bucket_name = "ecs-access-logs-kemist-dev"
app_name = "kemi_dev"
domain = "dev-api.kemist.io"
env_suffix = "dev"
tpl_path = "service.config.json.tpl"
```
