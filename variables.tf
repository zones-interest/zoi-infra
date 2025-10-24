variable "github_repo_url" {
  description = "GitHub repository URL"
  type        = string
}

variable "nextauth_secret" {
  description = "NextAuth secret key"
  type        = string
  default     = "8f2a9c4e7b1d6f3a5e8c9b2d4f7a1e6c3b8d5f2a9c4e7b1d6f3a5e8c9b2d4f7a"
}