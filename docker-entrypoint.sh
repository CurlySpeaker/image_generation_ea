if ! getent passwd "$(id -u)" &> /dev/null && [ -e /usr/lib/libnss_wrapper.so ]; then
    export LD_PRELOAD='/usr/lib/libnss_wrapper.so'
    export NSS_WRAPPER_PASSWD="$(mktemp)"
    export NSS_WRAPPER_GROUP="$(mktemp)"
    echo "daniel:x:$(id -u):$(id -g):Insert meme here:/project:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "daniel:x:$(id -g):" > "$NSS_WRAPPER_GROUP"
fi

if [ "$1" = "jupyter" ]; then
    tensorboard --logdir /model-logs --port=8080 &
    jupyter contrib nbextension install --user
    jupyter nbextensions_configurator enable --user
    mlflow ui -h 0.0.0.0 -p 5000 --file-store /mlflow &
    if [ "$FAKE_DISPLAY" = true ]; then
        export DISPLAY=':99.0'
        Xvfb :99 -screen 0 1400x900x24 > /dev/null 2>&1 &
    fi
    exec $@ --allow-root --NotebookApp.token=$JUPYTER_PASSWORD --no-browser --ip 0.0.0.0
fi
exec "$@"
