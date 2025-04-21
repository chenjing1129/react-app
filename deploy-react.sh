#!/bin/bash
set -eo pipefail

# 配置参数（可通过环境变量覆盖）
CONTAINER_NAME="${CONTAINER_NAME:-my-react-app}"          # 容器名称
IMAGE_NAME="${IMAGE_NAME:-crpi-omc65ozz650fnfe9.cn-shanghai.personal.cr.aliyuncs.com/jackson_chen/react-app}"  # 镜像地址
IMAGE_TAG="${IMAGE_TAG:-latest}"                       # 镜像标签
PORT_MAPPING="${PORT_MAPPING:-8080:80}"                  # 端口映射
ACR_REGISTRY="$(echo "$IMAGE_NAME" | cut -d '/' -f1)"  # 自动提取Registry地址

# 必需环境变量检查
: "${ACR_USERNAME:?必须设置ACR_USERNAME环境变量}"
: "${ACR_PASSWORD:?必须设置ACR_PASSWORD环境变量}"

# 带颜色输出的日志函数
log_info() {
    echo -e "\033[34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[32m[SUCCESS]\033[0m $1"
}

log_error() {
    echo -e "\033[31m[ERROR]\033[0m $1" >&2
}

# 容器管理函数
manage_container() {
    local action=$1
    if docker inspect "$CONTAINER_NAME" &>/dev/null; then
        case $action in
            stop)
                log_info "正在停止容器: $CONTAINER_NAME"
                docker stop "$CONTAINER_NAME" || true
                ;;
            remove)
                log_info "正在移除容器: $CONTAINER_NAME"
                docker rm -f "$CONTAINER_NAME" || true
                ;;
        esac
    else
        log_info "容器 $CONTAINER_NAME 不存在，跳过$action操作"
    fi
}

# 镜像清理函数
cleanup_images() {
    log_info "正在清理旧镜像..."
    local current_image_id
    current_image_id=$(docker images --format "{{.ID}}" "$IMAGE_NAME:$IMAGE_TAG" | head -n1)
    
    # 删除同一仓库的旧镜像（保留最近2个版本）
    docker images --filter "reference=$IMAGE_NAME" --format "{{.ID}} {{.Tag}}" | \
        awk -v keep_tags="$IMAGE_TAG" -v img_id="$current_image_id" '
        $1 != img_id && $2 != keep_tags {print $1}
        ' | sort -u | xargs -r docker rmi -f 2>/dev/null || true
}

# 主流程
main() {
    # 登录镜像仓库
    log_info "登录到阿里云容器镜像服务"
    echo "$ACR_PASSWORD" | docker login --username "$ACR_USERNAME" --password-stdin "$ACR_REGISTRY"

    # 停止并移除旧容器
    manage_container "stop"
    manage_container "remove"

    # 拉取新镜像
    log_info "正在拉取镜像: $IMAGE_NAME:$IMAGE_TAG"
    docker pull "$IMAGE_NAME:$IMAGE_TAG"

    # 启动新容器
    log_info "正在启动新容器"
    docker run -d \
        --name "$CONTAINER_NAME" \
        -p "$PORT_MAPPING" \
        --restart unless-stopped \
        "$IMAGE_NAME:$IMAGE_TAG"

    # 执行清理
    cleanup_images

    log_success "部署成功！新镜像版本: $(docker inspect --format '{{.Id}}' "$IMAGE_NAME:$IMAGE_TAG")"
}

# 异常处理
trap 'log_error "脚本执行异常，退出状态码: $?"; exit 1' ERR
main
