module StaticPagesHelper
  require 'coderay'

  def show_code_json source_code
    html = CodeRay.scan(source_code, :json).div(:line_numbers => :table, :break_lines => true)
  end
end
