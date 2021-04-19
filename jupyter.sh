docker run --rm \
    --gpus all \
    -v ${PWD}/code:/code \
    -p 8889:8888 \
    --ipc=host \
    dockerpytorch:latest 