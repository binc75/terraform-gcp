## Cluster 
resource "google_container_cluster" "gke-cluster" {
  name               = "gke-cluster"
  network            = "default"
  location           = var.zone
  initial_node_count = 3
}


## Additional worker nodes
resource "google_container_node_pool" "extra-pool" {
  name               = "extra-node-pool"
  location           = var.zone
  cluster            = google_container_cluster.gke-cluster.name
  initial_node_count = 2
}
