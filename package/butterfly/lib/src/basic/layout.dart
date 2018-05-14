part of butterfly;

/// A flexible element.
class Flex extends MultiChildNode {
  final FlexAlign align;
  final FlexDirection direction;
  final JustifyContent justifyContent;
  final FlexWrap wrap;

  const Flex({
    @required this.align,
    @required this.direction,
    @required this.justifyContent,
    @required this.wrap,
    @required List<Node> children,
    Key key,
  })
      : super(key: key, children: children);

  @override
  RenderNode instantiate(RenderParent parent) => new _FlexRenderNode(parent);
}

class _FlexRenderNode extends RenderMultiChildParent<Flex> {
  _FlexRenderNode(Tree tree) : super(tree);

  @override
  final Surface surface = new Surface();

  @override
  void update(Flex newConfiguration) {
    /// On the initial build, insert all styles.
    if (configuration == null) {
      surface
        ..display = 'flex'
        ..justifyContent = newConfiguration.justifyContent._value
        ..flexDirection = newConfiguration.direction._value
        ..flexWrap = newConfiguration.wrap._value
        ..alignItems = newConfiguration.align._value;
    } else if (!identical(newConfiguration, configuration)) {
      if (!identical(
          newConfiguration.justifyContent, configuration.justifyContent)) {
        surface.justifyContent = newConfiguration.justifyContent._value;
      }
      if (!identical(newConfiguration.wrap, configuration.wrap)) {
        surface.flexWrap = newConfiguration.wrap._value;
      }
      if (!identical(newConfiguration.align, configuration.align)) {
        surface.alignItems = newConfiguration.align._value;
      }
      if (!identical(newConfiguration.direction, configuration.direction)) {
        surface.flexDirection = newConfiguration.direction._value;
      }
    }
    super.update(newConfiguration);
  }
}

/// A flexible element with column oriented children.
class Column extends Flex {
  /// Create a new column node.
  const Column({
    Key key,
    List<Node> children = const [],
    FlexAlign align = FlexAlign.auto,
    JustifyContent justifyContent = JustifyContent.start,
    FlexWrap wrap = FlexWrap.noWrap,
  })
      : super(
          key: key,
          children: children,
          align: align,
          direction: FlexDirection.column,
          justifyContent: justifyContent,
          wrap: wrap,
        );
}

/// A flexible element with row oriented children.
class Row extends Flex {
  /// Create a new now node.
  const Row({
    Key key,
    List<Node> children = const [],
    FlexAlign align = FlexAlign.auto,
    JustifyContent justifyContent = JustifyContent.start,
    FlexWrap wrap = FlexWrap.noWrap,
  })
      : super(
          key: key,
          children: children,
          align: align,
          direction: FlexDirection.row,
          justifyContent: justifyContent,
          wrap: wrap,
        );
}

/// A decoration which allows absolutely positioning a child.
///
/// The offset from either the window or a previous `relative` element in px.
class Positioned extends Decoration {
  final String left;
  final String top;

  Positioned({
    double leftOffset = 0.0,
    double topOffset = 0.0,
    @required Widget child,
    Key key,
  })
      : left = '${leftOffset}px',
        top = '${topOffset}px',
        super(child: child, key: key);

  @override
  RenderDecoration instantiate(RenderParent parent) => new _PositionedDecoration(parent);
}

/// A [RenderNode] that applies absolute positioning to a child.
class _PositionedDecoration extends RenderDecoration<Positioned> {
  _PositionedDecoration(Tree tree) : super(tree);

  void update(Positioned newConfiguration) {
    if (!identical(newConfiguration, configuration)) {
      surface
        ..left = newConfiguration.left
        ..top = newConfiguration.left
        ..position = 'absoute';
    }
    super.update(newConfiguration);
  }
}

/// A decoration that controls the flex properties of a child.
class FlexChild extends Decoration {
  final int order;
  final double grow;
  final double shrink;
  final double basis;
  final FlexAlign alignSelf;

  const FlexChild({
    this.order,
    this.grow,
    this.shrink,
    this.basis,
    this.alignSelf,
    Key key,
    @required Node child,
  })
      : super(key: key, child: child);

  @override
  RenderDecoration instantiate(RenderParent parent) => new _FlexChildDecoration(parent);
}

/// A [RenderNode] that applies flex properties to a child element.
class _FlexChildDecoration extends RenderDecoration<FlexChild> {
  _FlexChildDecoration(Tree tree) : super(tree);

  void update(FlexChild newConfiguration) {
    if (!identical(newConfiguration, configuration)) {
      if (newConfiguration.order == null) {
        surface.order = null;
      } else {
        surface.order = '${newConfiguration.order}';
      }
      if (newConfiguration.grow == null) {
        surface.grow = null;
      } else {
        surface.grow = '${newConfiguration.grow}';
      }
      if (newConfiguration.shrink == null) {
        surface.shrink = null;
      } else {
        surface.shrink = '${newConfiguration.shrink}';
      }
      if (newConfiguration.basis == null) {
        surface.basis = null;
      } else {
        surface.basis = '${newConfiguration.basis}';
      }
      if (newConfiguration.alignSelf == null) {
        surface.alignSelf = null;
      } else {
        surface.alignSelf = newConfiguration.alignSelf._value;
      }
    }
    super.update(newConfiguration);
  }
}

/// Configuration for flex alignment properties.
@immutable
class FlexAlign {
  static const auto = const FlexAlign._('auto');
  static const start = const FlexAlign._('flex-start');
  static const end = const FlexAlign._('flex-end');
  static const center = const FlexAlign._('center');
  static const baseline = const FlexAlign._('baseline');
  static const stretch = const FlexAlign._('stretch');

  final String _value;

  const FlexAlign._(this._value);
}

/// Configuration for the flex direction.
@immutable
class FlexDirection {
  static const row = const FlexDirection._('row');
  static const rowReverse = const FlexDirection._('row-reverse');
  static const column = const FlexDirection._('column');
  static const columnReverse = const FlexDirection._('column-reverse');

  final String _value;

  const FlexDirection._(this._value);
}

/// Configuration for wrapping of flex items across lines.
@immutable
class FlexWrap {
  static const wrap = const FlexWrap._('wrap');
  static const noWrap = const FlexWrap._('no-wrap');
  static const wrapReverse = const FlexWrap._('wrap-reverse');

  final String _value;

  const FlexWrap._(this._value);
}

/// Configuration for justification of flex items.
@immutable
class JustifyContent {
  static const start = const JustifyContent._('start');
  static const end = const JustifyContent._('end');
  static const center = const JustifyContent._('center');
  static const spaceBetween = const JustifyContent._('space-between');
  static const spaceAround = const JustifyContent._('space-around');
  static const spaceEvenly = const JustifyContent._('space-evenly');

  final String _value;

  const JustifyContent._(this._value);
}
