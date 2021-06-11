echo "Run Jupyter Lab & VSCode & TTYD"
echo "Password: $PASSWORD"

if [ "$GH_REPO" ]
then
  echo "Github Repo: $GH_REPO"
  git clone ${GH_REPO}
  git config --global user.email "$USER_EMAIL"
  git config --global user.name "$USER_NAME"
fi
chmod -R 555 /workspace

git -C /workspace clone https://github.com/KLUE-benchmark/KLUE.git

apt-get update -y
apt-get upgrade -y
apt-get install git-lfs -y

git lfs install
git clone https://huggingface.co/klue/roberta-small

jupyter notebook  --NotebookApp.token=$PASSWORD --ip=0.0.0.0 --port=8000 --allow-root &

if [ -z "$PASSWORD" ]
then
AUTH=none
else
AUTH=password
fi
code-server /workspace/ --bind-addr=0.0.0.0:8010 --auth $AUTH &

if [ -z "$PASSWORD" ]
then
TTYD_PASS=
else
TTYD_PASS="-c :$PASSWORD"
fi
ttyd -p 8020 $TTYD_PASS bash &

tail -f /dev/null
