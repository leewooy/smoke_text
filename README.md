# SmokeText Flutter 위젯

## 개요
`SmokeText` 위젯은 주어진 텍스트에 연기처럼 퍼지는 애니메이션 효과를 생성합니다. 텍스트가 변경될 때마다(예: 버튼 클릭 시) 고유한 애니메이션이 트리거되며, 랜덤한 바람 방향과 투명도 변화가 적용됩니다. 이 위젯은 애플리케이션에 동적인 시각적 효과를 추가하는 데 유용합니다.

---

## 파일 구성
### `main.dart`
이 파일은 주요 애플리케이션 로직을 포함하며, `SmokeText` 위젯을 사용하는 방법을 보여줍니다.

#### 주요 특징:
- **상태 기반 카운터 예제**: 버튼 클릭 시 텍스트가 업데이트되는 예제를 제공합니다.
- **고유 연기 애니메이션**: `SmokeText` 위젯에 고유한 `Key`를 사용하여 버튼 클릭마다 새로운 애니메이션 효과를 생성합니다.

#### 예제 코드:
```dart
ElevatedButton(
  onPressed: () {
    setState(() {
      num++;
      _smokeKey = UniqueKey();
    });
  },
  child: const Text('Click me'),
);

ConstrainedBox(
  constraints: const BoxConstraints(maxHeight: 100),
  child: SmokeText(
    key: _smokeKey,
    text: '$num',
  ),
);
```
---

### `smoke_text.dart`
이 파일은 `SmokeText` 위젯과 커스텀 `SmokePainter`의 구현을 포함하고 있습니다. 애니메이션 효과는 `CustomPainter`와 Flutter의 애니메이션 시스템을 사용하여 생성됩니다.

#### 주요 특징:
1. **동적인 바람 방향:**
   - 각 애니메이션 인스턴스마다 랜덤한 바람 방향이 생성됩니다.
   - 매번 고유한 확산 효과를 제공합니다.

2. **투명도 및 확산 제어:**
   - 텍스트가 바깥쪽으로 퍼지면서 점점 사라지는 애니메이션을 구현합니다.
   - 여러 방향으로 점진적으로 텍스트를 확산시킵니다.

#### 예제 구현:
```dart
void _generateWindDirection() {
  _windDirection = Random().nextDouble() * 2 * pi;
}

void _setupAnimations() {
  _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
  );

  _controller.forward();
}
```

---

## 사용 방법
이 애니메이션을 프로젝트에 포함하려면:
1. `SmokeText` 위젯을 프로젝트 디렉토리에 추가합니다.
2. `Scaffold` 또는 `Column`과 같은 부모 위젯 안에 래핑합니다.
3. 원하는 텍스트를 `text` 속성으로 제공합니다.

#### 예제:
```dart
SmokeText(
  key: UniqueKey(), // 빌드 시 새로운 애니메이션 인스턴스를 보장
  text: 'Hello, World!',
);
```

---

## 커스터마이징
`smoke_text.dart`를 업데이트하여 애니메이션의 다음 항목을 수정할 수 있습니다:

1. **애니메이션 지속 시간:**
   - `AnimationController`의 지속 시간을 변경하여 연기 효과의 속도를 조절합니다.
   ```dart
   _controller = AnimationController(
     vsync: this,
     duration: const Duration(milliseconds: 2000),
   );
   ```

2. **바람 확산:**
   - `SmokePainter`의 `angleVariation` 또는 `maxSpread` 값을 조정하여 확산 범위를 제어합니다.
   ```dart
   double angleVariation = pi / 4; // 확산 각도 범위 조정
   final double maxSpread = 40.0; // 텍스트가 퍼지는 거리 제어
   ```

3. **투명도 수준:**
   - `SmokePainter`의 투명도 로직을 수정하여 더 극적인 효과를 추가합니다.
   ```dart
   final double layerOpacity = opacity * (1 - (copy / copies));
   ```

---

## 의존성
`pubspec.yaml` 파일에 다음을 포함하세요:
```yaml
dependencies:
  flutter:
    sdk: flutter
```

---

## 알려진 문제
1. **텍스트 겹침:**
   - `text` 문자열이 너무 길면, 확산 애니메이션 중 문자들이 겹칠 수 있습니다.
2. **성능:**
   - 광범위한 애니메이션은 저사양 기기에서 약간의 성능 저하를 유발할 수 있습니다. 복사본 수나 애니메이션 지속 시간을 줄여 최적화하세요.

---

## 향후 개선 사항
- 사용자 정의 색상 및 글꼴 스타일 지원 추가.
- 동적으로 연기 효과의 방향과 강도를 제어하는 옵션 제공.
- 성능 향상을 위한 `CustomPainter` 로직 최적화.

---

문의 사항이나 기여를 원하시면, 저장소 관리자에게 연락하거나 Pull Request를 제출하세요!

