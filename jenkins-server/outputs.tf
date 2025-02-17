output "jenkins_instance_public_ip" {
  value = aws_instance.jenkins_server.public_ip
  description = "Public IP address of the Jenkins server"
}
