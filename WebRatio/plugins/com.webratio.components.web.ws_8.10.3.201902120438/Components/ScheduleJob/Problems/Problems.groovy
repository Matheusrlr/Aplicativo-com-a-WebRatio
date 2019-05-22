def jobId = component["job"]

def name = component["name"] ? component["name"] : component["id"]

if (jobId == "") {
    addError("The job for the component " + name + " is unspecified.")
} 