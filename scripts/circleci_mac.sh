export UVCDAT_ANONYMOUS_LOG=False
export PATH=${HOME}/miniconda/bin:${PATH}
echo "CIRCLE CI BRANCH:"$CIRCLE_BRANCH
echo "CI_PULL_REQUESTS"$CI_PULL_REQUESTS
echo "CI_PULL_REQUEST"$CI_PULL_REQUEST
python run_tests.py -v2 -s
rc=$?
if [ ${rc} -ne 0 ]; then exit ${rc} ; fi
if [ ${rc} -eq 0 -a $CIRCLE_BRANCH == "master" ]; then bash ./scripts/conda_upload.sh ; fi
