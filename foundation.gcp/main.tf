provider "google"{
    project = "polytech"
    region = "europe-west1"
    zone = "europe-west-1-b"
    credentials = file("student.json")
}

