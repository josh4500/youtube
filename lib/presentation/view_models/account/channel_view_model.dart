class ChannelSnippet {
  const ChannelSnippet({
    required this.id,
    required this.name,
    required this.isLive,
    required this.tag,
  });

  final String id;
  final String tag;
  final bool isLive;
  final String name;

  static const ChannelSnippet test = ChannelSnippet(
    id: '',
    name: '',
    isLive: false,
    tag: '',
  );
}
