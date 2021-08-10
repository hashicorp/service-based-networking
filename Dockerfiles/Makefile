build_docker: build_docker_ubuntu build_docker_with_consul

build_docker_ubuntu:
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	docker buildx create --name multi || true
	docker buildx use multi
	docker buildx inspect --bootstrap
	docker buildx build --platform linux/arm64,linux/amd64 \
		-t nicholasjackson/ubuntu-systemd:latest \
    -f ./Dockerfile \
    . \
		--push
	docker buildx rm multi

build_docker_with_consul:
	docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	docker buildx create --name multi || true
	docker buildx use multi
	docker buildx inspect --bootstrap
	docker buildx build --platform linux/arm64,linux/amd64 \
		-t nicholasjackson/ubuntu-systemd:consul-1.10.1 \
    -f ./Dockerfile_with_consul \
    . \
		--push
	docker buildx rm multi