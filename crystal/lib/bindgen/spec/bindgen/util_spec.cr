require "../spec_helper"

describe "Util" do
  describe ".template" do
    it "handles strings without any replacement" do
      Bindgen::Util.template("Foo Bar", "TEMPL").should eq("Foo Bar")
    end

    context "character expansion" do
      it "handles one" do
        Bindgen::Util.template("Foo % Bar", "TEMPL").should eq("Foo TEMPL Bar")
      end

      it "handles multiple" do
        Bindgen::Util.template("Foo % Bar %", "TEMPL").should eq("Foo TEMPL Bar TEMPL")
      end
    end

    context "environment variable expansion" do
      it "doesn't expand at all if disabled" do
        Bindgen::Util.template("Foo % {UTIL_TEST} Bar", "TEMPL", env: false).should eq("Foo TEMPL {UTIL_TEST} Bar")
      end

      it "handles one" do
        env = { "UTIL_TEST" => "Okay" }
        Bindgen::Util.template("Foo {UTIL_TEST} Bar", "TEMPL", env: env).should eq("Foo Okay Bar")
      end

      it "handles environment variable and character expansion" do
        env = { "UTIL_TEST" => "Okay" }
        Bindgen::Util.template("Foo {UTIL_TEST} % Bar", "TEMPL", env: env).should eq("Foo Okay TEMPL Bar")
      end

      it "handles multiple" do
        env = { "FIRST" => "One", "SECOND" => "Two" }
        Bindgen::Util.template("Foo {FIRST} {SECOND} Bar", "TEMPL", env: env).should eq("Foo One Two Bar")
      end

      it "handles unused default" do
        env = { "UTIL_TEST" => "Five" }
        Bindgen::Util.template("Foo {UTIL_TEST|Wrong} Bar", "TEMPL", env: env).should eq("Foo Five Bar")
      end

      it "falls back to default" do
        env = { } of String => String
        Bindgen::Util.template("Foo {UNSET|Okay} Bar", "TEMPL", env: env).should eq("Foo Okay Bar")
      end

      it "falls back to character expansion" do
        env = { } of String => String
        Bindgen::Util.template("Foo {UNSET|%} Bar", "TEMPL", env: env).should eq("Foo TEMPL Bar")
      end

      it "falls back to complex character expansion" do
        env = { } of String => String
        Bindgen::Util.template("Foo {UNSET|<%>} Bar", "TEMPL", env: env).should eq("Foo <TEMPL> Bar")
      end
    end
  end
end
