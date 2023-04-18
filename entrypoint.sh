#!/bin/sh


echo "Authentication using ${INPUT_CREDENTIALS_TYPE}"

# serverExists () {
#   set +e
#   if [ "${err}" -ne 0 ]; then
#     if echo "${err}" |grep exists > /dev/null
#     then return
#     else
#         echo "Error: ${server}"
#         exit "${err}"
#     fi
#   fi
#   set -e
# }

# Authenticate to the server
if [ "${INPUT_REUSE}" = "true" ]; then
  echo "Reusing rt-server"
  return
elif [ "${INPUT_CREDENTIALS_TYPE}" = "username" ]; then
  jf c add rt-server --interactive=false --url="${INPUT_URL}" --user="${INPUT_USER}" --password="${INPUT_PASSWORD}"
elif [ "${INPUT_CREDENTIALS_TYPE}" = "apikey" ]; then
  jf c add rt-server --interactive=false --url="${INPUT_URL}" --apikey="${INPUT_APIKEY}"
elif [ "${INPUT_CREDENTIALS_TYPE}" = "accesstoken" ]; then
  jf c add rt-server --interactive=false --url="${INPUT_URL}" --access-token="${INPUT_ACCESS_TOKEN}"
fi
sh -c "jf config use rt-server"

# Set working directory if specified
if [ "${INPUT_WORKING_DIRECTORY}" != '.' ]; then
  cd "${INPUT_WORKING_DIRECTORY}" || exit
fi

# Log command for info
echo "[Info] jf $*"

# Capture output
output=$( sh -c "jf $*" )

# Preserve output for consumption by downstream actions
echo "${output}" > "${HOME}/${GITHUB_ACTION}.log"
cat "${HOME}/${GITHUB_ACTION}.log"

# Write output to STDOUT
echo "${output}"
