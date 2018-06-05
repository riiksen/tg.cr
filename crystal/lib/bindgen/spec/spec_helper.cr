require "spec"
require "../src/bindgen/library"

### Helpers

def watchdog(deadline = 10.seconds)
  # alarm() / SIGALRM doesn't trigger reliably :(
  watcher = Process.fork do
    sleep deadline
    STDERR.puts "WATCHDOG: Deadline reached after #{deadline.seconds}s"
    STDERR.puts "Aborting."
    Process.kill(Signal::ABRT, Process.ppid)
  end

  yield
ensure
  watcher.try(&.kill)
end

# Short-hand functions
module Parser
  include Bindgen::Parser

  def self.void_type
    Bindgen::Parser::Type::VOID
  end

  def self.type(cpp_type : String) : Bindgen::Parser::Type
    Bindgen::Parser::Type.parse(cpp_type)
  end

  def self.argument(name : String, cpp_type : String, default = nil, has_default = false) : Bindgen::Parser::Argument
    has_default ||= default != nil # Does it actually have a default?
    Bindgen::Parser::Argument.new(
      name: name,
      type: type(cpp_type),
      hasDefault: has_default,
      value: default,
    )
  end

  def self.method(name : String, class_name : String, result : Bindgen::Parser::Type, arguments : Array(Bindgen::Parser::Argument), type = Bindgen::Parser::Method::Type::MemberMethod)
    args = arguments.map do |arg|
      if arg.is_a?(Tuple)
        Parser.argument(*arg)
      else
        arg
      end
    end

    ret = result.is_a?(String) ? Parser.type(result) : result

    Bindgen::Parser::Method.new(
      type: type,
      access: Bindgen::Parser::AccessSpecifier::Public,
      name: name,
      className: class_name,
      arguments: args,
      returnType: ret,
      firstDefaultArgument: args.index(&.has_default?),
    )
  end

  def self.method(name : String, class_name : String, result : Bindgen::Parser::Type, type = Bindgen::Parser::Method::Type::MemberMethod)
    method(name, class_name, result, [ ] of Bindgen::Parser::Argument, type)
  end
end
