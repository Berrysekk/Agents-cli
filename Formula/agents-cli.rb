# brew tap berrysekk/agents-cli https://github.com/Berrysekk/Agents-cli
# brew trust berrysekk/agents-cli   (Homebrew 7 loads a tap only once you trust it)
# brew install agents-cli
class AgentsCli < Formula
  desc "Live tree of the running Claude Code sessions and their subagents"
  homepage "https://github.com/Berrysekk/Agents-cli"
  url "https://github.com/Berrysekk/Agents-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "73c3f37ac24aa3fe78573ef42b0d3318f2afbba3c5db0f8b8ad4ea923bc2e342"

  def install
    bin.install "agents"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agents version")
    assert_match "ok", shell_output("#{bin}/agents selftest")
  end
end
