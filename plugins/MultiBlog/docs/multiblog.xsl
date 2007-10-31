<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:import href="/usr/local/share/xsl/docbook/xhtml/chunk.xsl" />
<xsl:param name="use.id.as.filename" select="1" />
<xsl:param name="chunk.first.sections" select="1" />
<xsl:param name="chunk.section.depth" select="2" />
<xsl:param name="generate.section.toc.level" select="1" />
<xsl:param name="html.stylesheet" select="'http://www.rayners.org/plugins/docs.css'" />

<xsl:template match="code">
  <pre><xsl:call-template name="inline.monoseq" /></pre>
</xsl:template>

</xsl:stylesheet>
