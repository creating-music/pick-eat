import 'dart:math';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';
import 'package:pick_eat/game/constant/ball_color.dart';

class LottoMachineGame extends Forge2DGame with HasCollisionDetection {
  final Vector2 widgetSize;

  // 바람 제어용 타이머
  double _elapsedTime = 0.0;
  final double _mixingDuration = 5.0; // 5초간 섞기
  bool get _isMixingPhase => _elapsedTime < _mixingDuration;

  // 구멍 막기용 컴포넌트
  late BodyComponent _holePlug;

  LottoMachineGame({required this.widgetSize})
    : super(gravity: Vector2(0, 60)); // 중력 증가

  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: widgetSize);

    ///////////////////////// machine ///////////////////////////
    final bodyRadius = min(widgetSize.x / 4, widgetSize.y / 4);
    final bodyCenter = Vector2(widgetSize.x / 2, widgetSize.y / 2.5);
    add(MachineBody(startPosition: bodyCenter, radius: bodyRadius));
    add(
      MachineBottomBack(
        position: bodyCenter + Vector2(0, bodyRadius * 1.47),
        radius: bodyRadius / 2,
      ),
    );

    /////////////////////////// ball ////////////////////////////
    List<int> numbers = List.generate(
      BallColor.values.length,
      (index) => index,
    );
    numbers.shuffle(Random());

    for (int i = 0; i < BallColor.values.length; i++) {
      final color = BallColor.values[i];
      final ballRadius = min(widgetSize.x / 23, widgetSize.y / 23);
      final index = numbers[i];
      final center = Vector2(
        widgetSize.x / 2 +
            min(widgetSize.x, widgetSize.y) *
                (index * 0.01 * (index % 2 == 0 ? 1 : -1)),
        widgetSize.y / 2.5 +
            min(widgetSize.x, widgetSize.y) *
                (index * 0.01 * (index % 3 == 0 ? 1 : -1)),
      );
      add(Ball(startPosition: center, radius: ballRadius, color: color));
    }
    //////////////////////// Machine Hat //////////////////
    add(
      MachineHat(
        position: bodyCenter - Vector2(0, bodyRadius),
        radius: bodyRadius / 2,
      ),
    );

    ////////////////////////// Machine Bottom ///////////////////
    add(
      MachineBottom(
        position: bodyCenter + Vector2(0, bodyRadius * 1.47),
        radius: bodyRadius / 2,
      ),
    );

    //////////////////////// Hole Plug (섞기 단계용) ///////////////////
    _holePlug = HolePlug(
      position: bodyCenter + Vector2(0, bodyRadius), // MachineBody 최하단
      radius: bodyRadius * 0.15, // 구멍 크기에 맞춤
    );
    add(_holePlug);
  }

  @override
  void update(double dt) {
    // 화면 크기에 따른 시간 스케일링으로 속도 정규화
    const double baseSize = 5.0; // 기준 화면 최소 크기
    final double currentMinSize = min(widgetSize.x, widgetSize.y);
    final double timeScale = sqrt(currentMinSize) / baseSize; // 작은 화면일수록 느리게
    final double adjustedDt = dt * timeScale;
    // double adjustedDt = 3 * dt;

    super.update(adjustedDt);

    // 타이머 업데이트
    _elapsedTime += dt;

    // 5초 후 구멍 열기
    if (_elapsedTime >= _mixingDuration && _holePlug.isMounted) {
      remove(_holePlug);
    }

    // MachineBody 기준 중심에서 아래쪽으로 일정 영역 설정
    final bodyRadius = min(widgetSize.x / 5, widgetSize.y / 5);
    final bodyCenterX = widgetSize.x / 2;
    final bodyCenterY = widgetSize.y / 2.5;

    final double windZoneMTop = bodyCenterY - bodyRadius * 1.5;
    final double windZoneMBottom = bodyCenterY + bodyRadius * 2.2;
    final double windZoneMLeft = bodyCenterX - bodyRadius * 1.6;
    final double windZoneMRight = bodyCenterX + bodyRadius * 1.6;
    final double windZoneTop = bodyCenterY - bodyRadius * 0.2;
    final double windZoneBottom = bodyCenterY + bodyRadius * 0.8;
    final double windZoneLeft = bodyCenterX - bodyRadius * 0.4;
    final double windZoneRight = bodyCenterX + bodyRadius * 0.4;

    // Ball 컴포넌트들에게 바람을 적용
    for (final component in children) {
      if (component is Ball) {
        final ball = component;
        final body = ball.body;
        final random = Random();
        final windDirection = random.nextBool() ? 1 : -1;

        if (body.position.y >= windZoneMTop &&
            body.position.y <= windZoneMBottom &&
            body.position.x >= windZoneMLeft &&
            body.position.x <= windZoneMRight) {
          if (body.position.y >= windZoneTop &&
              body.position.y <= windZoneBottom &&
              body.position.x >= windZoneLeft &&
              body.position.x <= windZoneRight) {
            // 랜덤으로 바람 방향 결정
            body.applyForce(Vector2(100000000.0 * windDirection, -400000000));
          } else {
            body.applyForce(Vector2(1000000.0 * windDirection, -6000000));
          }
        }
      }
    }
  }
}

class BallHitbox extends PositionComponent with CollisionCallbacks {
  final double radius;
  final BallColor ballColor;

  BallHitbox({required this.radius, required this.ballColor});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(radius: radius));
  }
}

class Ball extends BodyComponent {
  final Vector2 startPosition;
  final double radius; // 👉 크기를 외부에서 지정
  final BallColor color;

  late final Svg svg;
  late final BallHitbox ballHitbox;

  Ball({
    required this.startPosition,
    required this.radius,
    required this.color,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    svg = await Svg.load(color.imagePath);

    // 별도의 PositionComponent로 hitbox 관리
    ballHitbox = BallHitbox(radius: radius, ballColor: color);
    add(ballHitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // hitbox 위치를 body 위치와 동기화
    ballHitbox.position = body.position;
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;

    // 화면 크기에 따른 밀도 조정으로 질량 균형 맞추기
    final game = findGame()! as LottoMachineGame;
    const double baseSize = 400.0; // 기준 화면 크기
    final double currentMinSize = min(game.widgetSize.x, game.widgetSize.y);
    final double sizeRatio = radius * radius / baseSize;

    // 밀도를 크기에 반비례하게 조정하여 질량을 균등하게 유지
    final double adjustedDensity = 100.0 / sizeRatio;

    // 화면 크기에 비례한 restitution 조정으로 상대적 튀어오름 높이 일정화
    const double baseRestitution = 1; // 확실히 눈에 보이도록 대폭 증가
    final double screenRatio = currentMinSize / baseSize;
    final double adjustedRestitution = baseRestitution * screenRatio;

    // 면적 역비례 friction 조정 (작은 공은 높은 friction, 큰 공은 낮은 friction)
    const double baseFriction = 0.5;
    const double baseRadius = 400.0 / 23; // 기준 공 크기
    final double adjustedFriction = baseFriction * (baseRadius / radius);

    final fixtureDef =
        FixtureDef(shape)
          ..density = adjustedDensity
          ..restitution = 0.8
          ..friction = 0.08;

    final bodyDef =
        BodyDef()
          ..type = BodyType.dynamic
          ..position = startPosition;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final size = Vector2.all(radius * 2);

    canvas.save();

    // 회전 중심을 원 중심으로 이동
    canvas.translate(0, 0);

    // 바디의 회전 각도 적용 (radian 단위)
    canvas.rotate(body.angle);

    // 이미지 그릴 때 중심 정렬을 위해 반지름만큼 이동
    canvas.translate(-radius, -radius);

    svg.render(canvas, size);

    canvas.restore();
  }
}

class MachineBody extends BodyComponent {
  final Vector2 startPosition;
  final double radius; // 👉 크기를 외부에서 지정

  late final Svg svg;

  MachineBody({required this.startPosition, required this.radius});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    svg = await Svg.load('images/lotto/machine/machine-body.svg');
  }

  @override
  Body createBody() {
    final bodyDef =
        BodyDef()
          ..type = BodyType.static
          ..position = startPosition;

    final body = world.createBody(bodyDef);

    final int segmentCount = 128;
    final double angleStep = 2 * pi / segmentCount;
    final double wallThickness = radius * 0.01; // 얇은 벽 두께

    for (int i = 0; i < segmentCount; i++) {
      final angle = i * angleStep;
      final x = cos(angle) * radius;
      final y = sin(angle) * radius;

      final double exitStartAngle = (75 / 180) * pi; // 출구 시작 각도 (하단 중앙)
      final double exitEndAngle = (105 / 180) * pi;

      final startAngle = i * angleStep;

      // 구멍
      if (startAngle >= exitStartAngle && startAngle <= exitEndAngle) {
        continue;
      }

      final wallPosition = Vector2(x, y);
      final rotation = angle;

      final shape =
          PolygonShape()..setAsBox(
            wallThickness / 2,
            radius * 0.05, // 세로 길이
            wallPosition, // 중심 위치 (MachineBody 기준 상대 좌표)
            rotation, // 회전 각도
          );

      final fixtureDef =
          FixtureDef(shape)
            ..friction = 0.9
            ..restitution = 0.5;

      body.createFixture(fixtureDef);
    }

    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final size = Vector2.all(radius * 2);
    canvas.translate(-radius, -radius);
    svg.render(canvas, size);
  }
}

class MachineHat extends BodyComponent {
  final Vector2 position;
  final double radius;
  late final Svg svg;

  MachineHat({required this.position, required this.radius});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    svg = await Svg.load('images/lotto/machine/machine-hat.svg');
  }

  @override
  Body createBody() {
    final bodyDef =
        BodyDef()
          ..type = BodyType.static
          ..position = position;

    final body = world.createBody(bodyDef);
    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    double diff = radius * 1.6;
    canvas.translate(-diff / 2, -diff / 2);
    final size = Vector2.all(diff);
    svg.render(canvas, size);
  }
}

class MachineBottomHitbox extends PositionComponent with CollisionCallbacks {
  final double radius;
  final Set<BallHitbox> _collidedBalls = <BallHitbox>{};

  MachineBottomHitbox({required this.radius});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // bottomShape에 해당하는 RectangleHitbox 추가
    add(
      RectangleHitbox(
        size: Vector2(radius * 2.5, radius * 0.2),
        position: Vector2(0, radius * 1.1),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  bool onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BallHitbox) {
      // 이미 충돌한 Ball인지 확인
      if (!_collidedBalls.contains(other)) {
        _collidedBalls.add(other);

        // TODO: 화면 전환 함수 여기에 넣기.

        // 1-2초 지연 후 출력
        Future.delayed(Duration(seconds: 1), () {
          debugPrint('Ball이 MachineBottom의 bottomShape에 충돌했습니다!');
          debugPrint('충돌한 Ball 색상: ${other.ballColor}');
        });
      }
    }
    return true;
  }
}

class MachineBottom extends BodyComponent {
  final Vector2 position;
  final double radius;
  late final Svg svg;
  late final MachineBottomHitbox bottomHitbox;

  MachineBottom({required this.position, required this.radius});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    svg = await Svg.load('images/lotto/machine/machine-bottom.svg');
    setColor(Colors.black);
    setAlpha(0);

    // 별도의 PositionComponent로 hitbox 관리
    bottomHitbox = MachineBottomHitbox(radius: radius);
    bottomHitbox.position = position;
    add(bottomHitbox);
  }

  @override
  Body createBody() {
    final bodyDef =
        BodyDef()
          ..type = BodyType.static
          ..position = position;

    final body = world.createBody(bodyDef);

    // 숨겨진 가상 충돌 바닥 추가
    final bottomShape =
        PolygonShape()..setAsBox(
          (radius * 2.5) / 2,
          (radius * 0.2) / 2,
          Vector2(0, radius * 1.1),
          0,
        );

    final bottomFixtureDef =
        FixtureDef(bottomShape)
          ..isSensor =
              false // 충돌 감지는 하지만 렌더링은 안함
          ..friction = 0.5;

    body.createFixture(bottomFixtureDef);

    final leftShape =
        PolygonShape()..setAsBox(
          (radius * 0.5) / 2,
          (radius * 2.5) / 2,
          Vector2(-radius / 1.5, radius * 0.2),
          0,
        );

    final leftFixtureDef =
        FixtureDef(leftShape)
          ..isSensor =
              false // 충돌 감지는 하지만 렌더링은 안함
          ..friction = 0.5;

    body.createFixture(leftFixtureDef);

    final rightShape =
        PolygonShape()..setAsBox(
          (radius * 0.5) / 2,
          (radius * 2.5) / 2,
          Vector2(radius / 1.5, radius * 0.2),
          0,
        );

    final rightFixtureDef =
        FixtureDef(rightShape)
          ..isSensor =
              false // 충돌 감지는 하지만 렌더링은 안함
          ..friction = 0.5;

    body.createFixture(rightFixtureDef);

    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    double diff = radius * 4.8;
    canvas.translate(-diff / 2, -diff / 2);
    final size = Vector2.all(diff);
    svg.render(canvas, size);
  }
}

class MachineBottomBack extends BodyComponent {
  final Vector2 position;
  final double radius;
  late final Svg svg;

  MachineBottomBack({required this.position, required this.radius});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    svg = await Svg.load('images/lotto/machine/machine-bottom-back.svg');
  }

  @override
  Body createBody() {
    final bodyDef =
        BodyDef()
          ..type = BodyType.static
          ..position = position;

    final body = world.createBody(bodyDef);
    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    double diff = radius * 3;
    canvas.translate(-diff / 2, -diff / 2);
    final size = Vector2.all(diff);
    svg.render(canvas, size);
  }
}

class HolePlug extends BodyComponent {
  final Vector2 position;
  final double radius;

  HolePlug({required this.position, required this.radius});

  @override
  Body createBody() {
    final bodyDef =
        BodyDef()
          ..type = BodyType.static
          ..position = position;

    final body = world.createBody(bodyDef);

    // 구멍을 막는 직사각형 벽 (더 효과적)
    final shape =
        PolygonShape()..setAsBox(
          radius * 1.2, // 너비: 구멍보다 조금 더 넓게
          radius * 0.2, // 높이: 얇은 판 형태
          Vector2.zero(), // 중심 위치
          0, // 회전 없음
        );

    final fixtureDef =
        FixtureDef(shape)
          ..friction = 0.5
          ..restitution = 0.8;

    body.createFixture(fixtureDef);
    return body;
  }

  @override
  void render(Canvas canvas) {
    // 완전히 보이지 않도록 렌더링 생략
    // super.render(canvas); ← 주석 처리로 완전 투명
  }
}
