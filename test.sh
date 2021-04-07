original="$(cat 'original.txt')"
# 多分マルチバイト文字じゃないと再現しない
echo "$original" > '日本語のファイル名'

# 多分ここにsleepを入れると再現しなくなる
# sleep 1

mirror="$(echo "$original")"
echo "$mirror" > 'mirror.txt'
