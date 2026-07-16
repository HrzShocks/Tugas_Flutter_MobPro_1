from docx import Document
from docx.shared import Pt, RGBColor

def apply_styles():
    doc = Document('manual_book.docx')

    # Heading 1
    if 'Heading 1' in doc.styles:
        h1 = doc.styles['Heading 1']
        h1.font.name = 'Outfit'
        h1.font.size = Pt(18)
        h1.font.bold = True
        h1.font.color.rgb = RGBColor(0x3B, 0x82, 0xF6)

    # Heading 2
    if 'Heading 2' in doc.styles:
        h2 = doc.styles['Heading 2']
        h2.font.name = 'Outfit'
        h2.font.size = Pt(14)
        h2.font.bold = True
        h2.font.color.rgb = RGBColor(0x00, 0x00, 0x00)

    # Heading 3
    if 'Heading 3' in doc.styles:
        h3 = doc.styles['Heading 3']
        h3.font.name = 'Inter'
        h3.font.size = Pt(12)
        h3.font.bold = True
        h3.font.color.rgb = RGBColor(0x00, 0x00, 0x00)

    # Normal
    if 'Normal' in doc.styles:
        normal = doc.styles['Normal']
        normal.font.name = 'Inter'
        normal.font.size = Pt(11)
        normal.font.color.rgb = RGBColor(0x33, 0x33, 0x33)

    doc.save('manual_book.docx')
    print("Styles applied successfully to manual_book.docx")

if __name__ == '__main__':
    apply_styles()
