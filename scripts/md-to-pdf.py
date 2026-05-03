"""Convert a markdown file to a styled PDF using markdown + xhtml2pdf."""
import sys
import markdown
from xhtml2pdf import pisa
import os

def md_to_pdf(md_path, pdf_path):
    with open(md_path, encoding='utf-8') as f:
        md_content = f.read()

    html_body = markdown.markdown(
        md_content,
        extensions=['tables', 'footnotes', 'smarty', 'md_in_html'],
        output_format='html5'
    )

    css = """
    @page {
        size: A4 landscape;
        margin: 1.5cm 2cm;
        @frame footer {
            -pdf-frame-content: footerContent;
            bottom: 0cm;
            margin-left: 2cm;
            margin-right: 2cm;
            height: 1cm;
        }
    }
    body {
        font-family: 'Segoe UI', Calibri, Arial, sans-serif;
        font-size: 9pt;
        line-height: 1.4;
        color: #1a1a1a;
    }
    h1 {
        font-size: 18pt;
        color: #0078D4;
        border-bottom: 2pt solid #0078D4;
        padding-bottom: 4pt;
        margin-top: 0;
    }
    h2 {
        font-size: 14pt;
        color: #0078D4;
        margin-top: 16pt;
        border-bottom: 1pt solid #d0d0d0;
        padding-bottom: 3pt;
    }
    h3 {
        font-size: 11pt;
        color: #333333;
        margin-top: 12pt;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin: 8pt 0;
        font-size: 8pt;
    }
    th {
        background-color: #0078D4;
        color: white;
        padding: 5pt 6pt;
        text-align: left;
        font-weight: bold;
    }
    td {
        padding: 4pt 6pt;
        border: 0.5pt solid #d0d0d0;
        vertical-align: top;
    }
    tr:nth-child(even) td {
        background-color: #f5f5f5;
    }
    strong {
        color: #1a1a1a;
    }
    hr {
        border: none;
        border-top: 1pt solid #d0d0d0;
        margin: 12pt 0;
    }
    p {
        margin: 4pt 0;
    }
    blockquote {
        border-left: 3pt solid #0078D4;
        padding-left: 8pt;
        margin-left: 0;
        color: #555;
        font-style: italic;
    }
    .footnote {
        font-size: 7pt;
        color: #666;
    }
    sup {
        font-size: 6pt;
    }
    """

    html = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>{css}</style>
</head>
<body>
{html_body}
<div id="footerContent">
<p style="font-size: 7pt; color: #888; text-align: center;">your company Internal - your product Competitive Analysis</p>
</div>
</body>
</html>"""

    with open(pdf_path, 'wb') as pdf_file:
        status = pisa.CreatePDF(html, dest=pdf_file, encoding='utf-8')

    if status.err:
        print(f"Error generating PDF: {status.err}")
        return False
    else:
        size_kb = os.path.getsize(pdf_path) / 1024
        print(f"PDF generated: {pdf_path} ({size_kb:.0f} KB)")
        return True

if __name__ == '__main__':
    md_path = sys.argv[1]
    pdf_path = sys.argv[2] if len(sys.argv) > 2 else md_path.replace('.md', '.pdf')
    md_to_pdf(md_path, pdf_path)
