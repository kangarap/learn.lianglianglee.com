/**
 * Prism.js 加载器 - 实现一次引入，多页面复用
 * 功能：动态加载 Prism.js 及相关主题和语言支持
 */
(function() {
  // 避免重复加载
  if (window.prismLoaded) return;
  window.prismLoaded = true;

  // 创建 link 标签加载 CSS 主题
  const cssLink = document.createElement('link');
  cssLink.rel = 'stylesheet';
  cssLink.href = 'https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css';
  document.head.appendChild(cssLink);

  // 加载 Prism 核心脚本
  const prismScript = document.createElement('script');
  prismScript.src = 'https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js';
  prismScript.onload = function() {
    // Prism 加载完成后，加载 Java 语言支持
    const javaScript = document.createElement('script');
    javaScript.src = 'https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-java.min.js';
    javaScript.onload = function() {
      // 所有脚本加载完成，对页面已有的代码块进行高亮
      if (window.Prism) {
        Prism.highlightAll();
      }
    };
    document.head.appendChild(javaScript);
  };
  document.head.appendChild(prismScript);
})();
