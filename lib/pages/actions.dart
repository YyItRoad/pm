import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

const resContext = {
  "intr": {
    'en': """
    <h1>
        Introduction
    </h1>
     <p><b>Overview：</b><br>High-definition Mito dynamic theme Daquan, a high-definition viewing software that looks at the
      beauty of the world.</p>
    <p>
        <b> Detailed：</b><br>Picture Master is a featured photo browsing software. In this application, you can see all
        kinds of
        beautiful high-quality pictures, high-definition mobile wallpapers, and massive network photos. There is always
        a touch on you.
    </p>
    <h1>
        Characteristics
    </h1>
    <p>
        Smooth operation experience, look at pictures more refreshing.
        Push featured images based on user preferences.
        Refine the atlas and picture features to make the content richer.
    </p>
    <h1>Copyright</h1>
    <p>Picture Master's photo resource sources are as follows:</p>
    <ul>
    <li> Copyright cooperation resources<p>Such resources belong to the works purchased by PM</p>
    </li>
    <li> Original works resources<p>Original assets uploaded by PM-certified users</p>
    </li>
    <li> Free cooperation resources<p>Such resources are provided by copyrighted partners and are free for PM users.</p>
    </li>
    </ul>
     """,
    'zh': """
    <h1>应用介绍</h1>
      <p><b>简述:</b><br>高清美图动态主题大全，一款看遍全世界美景的高清看图软件。</p>
    <p>
      <b>详述:</b><br>Picture Master是一款精选图片浏览软件，在此应用中你能看到各种类型精美的高质量图片，有高清的手机壁纸，还有海量的网络美图，总有一张打动你。
    </p>
    <h1>软件特色</h1>
    <p>
        流畅的操作体验，看图更爽快。
        根据用户喜好，推送精选图片。
        精制图集与图片专题，让内容更丰富。
    </p>
    <h1>版权说明</h1>
    <p>Picture Master 的图片资源来源如下：</p>
    <ul>
    <li> 版权合作资源<p>此类资源属于PM购买的作品</p>
    </li>
    <li> 原创作品资源<p>此类资源由PM认证的用户上传的原创作品</p>
    </li>
    <li> 免费合作资源<p>此类资源由拥有版权的合作方提供，PM用户可免费使用</p>
    </li>
    </ul>
    """
  },
  "help": {
    "en": """
    <p><b>Browse image: </b><br>Swipe down to see more images.</p>
    <p><b>Download the picture:</b><br>After entering the big picture, click the download button to download the picture to the
    phone.</p>
    """,
    "zh": """
    <p><b>浏览图片: </b><br>向下滑动可查看更多图片。</p>
    <p><b>下载图片: </b><br>进入大图后，点击下载按钮，将图片下载至手机。</p>
    """
  },
  "about": {
    "en": """
    <p>Yes, we are creating a better picture experience and future. Welcome to contact us and join us。</p>
    <u>dhn2017vip@gmail.com</u>
    """,
    "zh": """
    <p>没错，我们在创作更好的图片体验和未来。欢迎与我们联系并加入我们。</p>
    <u>dhn2017vip@gmail.com</u>
    """
  },
};

String getLocale(BuildContext context) {
  Locale local = FlutterI18n.currentLocale(context);
  return local != null ? local.languageCode : 'en';
}

class IntrPage extends StatelessWidget {
  const IntrPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, "actions.intr"),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Html(
          data: resContext['intr'][getLocale(context)],
          padding: EdgeInsets.all(8.0),
          defaultTextStyle: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, "actions.help"),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Html(
          data: resContext['help'][getLocale(context)],
          padding: EdgeInsets.all(8.0),
          defaultTextStyle: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, "actions.about"),
        ),
      ),
      body: Html(
        data: resContext['about'][getLocale(context)],
        padding: EdgeInsets.all(8.0),
        defaultTextStyle: TextStyle(fontSize: 20.0),
      ),
    );
  }
}
