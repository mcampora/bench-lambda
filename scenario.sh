run_tests() {
    MSG=$1
    LABEL=$2
    IMPLEM=$3
    NB=$4
    echo "${MSG}"
    pushd ${IMPLEM}
    # Run NBx the test
    for ((n=0; n<${NB}; n++)); do
        echo "Run nb ${n}"
        # build and deploy the function
        ./2-deploy-function.sh ${LABEL}
        # generate 10x hits
        ./3-invoke-function.sh ${LABEL}
        # cleanup the function
        ./4-cleanup-function.sh
    done
    popd
}

NB=1
mkdir ./results

# create the bucket
./1-create-bucket.sh

# run JavaScript tests
run_tests "Run the JavaScript test" "basic" ./nodejs-basic ${NB}

# run Java basic tests
run_tests "Run the basic Java test" "nosnap" ./java-basic ${NB}

# run Java tests with snapstart
run_tests "Run the Java test with snapstart" "snap" ./java-basic ${NB}

# run Java Springboot tests
run_tests "Run the SpringBoot test" "nosnap" ./springboot2 ${NB}

# run Java Springboot tests with snapstart
run_tests "Run the SpringBoot test with snapstart" "snap" ./springboot2 ${NB}

# cleanup the bucket
./5-cleanup-bucket.sh

