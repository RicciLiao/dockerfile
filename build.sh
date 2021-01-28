base_path=$(pwd)
build_target=$1
image_name=$2
build_target_path="$base_path"/"$build_target"

if [ "$build_target" = "1-RocketMQ" ]; then
  echo "not ready for this dockerfile"
  return
fi

if [ -z "$image_name" ]; then
  echo "wrong image name"
  return
fi

if [ -z "$build_target" ]; then
  echo "wrong build target"
  return
elif [ ! -d "$build_target_path" ]; then
  echo "target path not exsit"
  return
elif [ ! -s "$build_target_path"/Dockerfile ]; then
  echo "dockerfile not exsit"
  return
fi
echo "Start building image..."
cp "$build_target_path"/Dockerfile "$base_path"/Dockerfile

docker build \
-t "$image_name" .

rm -f "$base_path"/Dockerfile

