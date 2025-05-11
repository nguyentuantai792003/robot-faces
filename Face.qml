import QtQuick 2.0

Item {
    id: face

    property alias leftEyeBag: leftEyeBag
    property alias rightEyeBag: rightEyeBag
    property alias leftEye: leftEye
    property alias rightEye: rightEye
    property alias leftEyebrow: leftEyebrow
    property alias rightEyebrow: rightEyebrow
    property alias mouth: mouth
    property alias nose: nose

    function reset() {
        face.mouth.yOffset = 0;
        face.mouth.cornerYOffset = 0;
        face.mouth.teethRotation = 0;
        face.mouth.toothHeight = face.mouth.restingToothHeight;
        face.mouth.visibleRangeMin = 4;
        face.mouth.visibleRangeMax = 6;
        face.mouth.block.visible = false;
        face.leftEyeBag.visible = false;
        face.rightEyeBag.visible = false;
        face.leftEyebrow.rotation = 0;
        face.rightEyebrow.rotation = 0;
        face.leftEyebrow.y = face.leftEyebrow.restingY;
        face.rightEyebrow.y = face.rightEyebrow.restingY;
    }

    Rectangle {
        id: leftEyeBag
        x: leftEye.x + leftEye.width / 2 - width / 2
        y: restingY
        width: leftEye.restingWidth - 10
        height: width
        color: "black"
        radius: width / 2
        visible: false

        readonly property real restingY: leftEye.y + leftEye.height / 2 - height / 2
    }

    Rectangle {
        id: rightEyeBag
        x: rightEye.x + rightEye.width / 2 - width / 2
        y: restingY
        width: rightEye.restingWidth - 10
        height: width
        color: "black"
        radius: width / 2
        visible: false

        readonly property real restingY: rightEye.y + rightEye.height / 2 - height / 2
    }

    Eye {
        id: leftEye

        restingX: 95
        restingY: 85

        // QTBUG-51043
        Component.onCompleted: {
            pupil.restingX = pupil.parent.width / 2;
            pupil.restingY = pupil.parent.height / 2 + 15;
        }
    }

    Eye {
        id: rightEye

        restingX: 380
        restingY: 85

        Component.onCompleted: {
            pupil.restingX = pupil.parent.width / 2 - pupil.restingWidth;
            pupil.restingY = pupil.parent.height / 2 + 15;
        }
    }

    Eyebrow {
        id: leftEyebrow
        transformOrigin: Item.BottomLeft

        restingX: leftEye.restingX + leftEye.restingWidth
        restingY: nose.y - height
    }

    Eyebrow {
        id: rightEyebrow
        // Flip image horizontally
        transform: [
            Rotation {
                origin.x: rightEyebrow.width / 2
                origin.y: rightEyebrow.height / 2
                axis.z: 1
                angle: 180
            },
            Scale {
                origin.y: rightEyebrow.height / 2
                yScale: -1
            }
        ]
        // Because we flip the image, we don't use BottomRight here.
        transformOrigin: Item.BottomLeft

        restingX: rightEye.restingX - width
        restingY: nose.y - height
    }

    Nose {
        id: nose

        x: 278
        y: 182
    }

    Mouth {
        id: mouth

        x: 120
        y: 355
    }

    states: [
        State {
            name: "Idle"
        },
        State {
            name: "Happy"
        },
        State {
            name: "Sad"
        },
        State {
            name: "Crying"
        },
        State {
            name: "Startled"
        },
        State {
            name: "Dizzy"
        },
        State {
            name: "Angry"
        },
        State {
            name: "Suspicious"
        },
        State {
            name: "Bored"
        }
    ]

    transitions: [
        Transition {
            from: "Idle"
            to: "Happy"
            ToHappyAnimation {
                face: face
            }
        },
        Transition {
            from: "Happy"
            to: "Idle"
            FromHappyAnimation {
                face: face
            }
        },
        Transition {
            from: "Idle"
            to: "Sad"
            ToSadAnimation {
                face: face
            }
        },
        Transition {
            from: "Sad"
            to: "Idle"
            FromSadAnimation {
                face: face
            }
        },
        Transition {
            from: "Idle"
            to: "Crying"
            ToCryingAnimation {
                face: face
            }
        },
        Transition {
            from: "Crying"
            to: "Idle"
            FromCryingAnimation {
                face: face
            }
        },
        Transition {
            from: "Idle"
            to: "Startled"
            ToStartledAnimation {
                face: face
            }
        },
        Transition {
            from: "Startled"
            to: "Idle"
            FromStartledAnimation {
                face: face
            }
        },
        Transition {
            from: "Idle"
            to: "Dizzy"
            ToDizzyAnimation {
                face: face
            }
        },
        Transition {
            from: "Dizzy"
            to: "Idle"
            FromDizzyAnimation {
                face: face
            }
        },
        Transition {
            from: "Idle"
            to: "Angry"
            ToAngryAnimation {
                face: face
            }
        },
        Transition {
            from: "Angry"
            to: "Idle"
            FromAngryAnimation {
                face: face
            }
        },
        Transition {
            from: "Idle"
            to: "Suspicious"
            ToSuspiciousAnimation {
                face: face
            }
        },
        Transition {
            from: "Suspicious"
            to: "Idle"
            FromSuspiciousAnimation {
                face: face
            }
        },
        Transition {
            from: "Idle"
            to: "Bored"
            ToBoredAnimation {
                face: face
            }
        },
        Transition {
            from: "Bored"
            to: "Idle"
            FromBoredAnimation {
                face: face
            }
        }
    ]
    state: "Idle"

    function setEmotion(emotion) {
        // If we already in an emotion, do nothing
        if (face.state === emotion)
            return;

        // The Idle emotion can be set at any time
        if (emotion === "Idle") {
            face.state = "Happy";
            return;
        }

        // First reset to Idle, then to the target emotion
        face.state = "Idle";
        emotionChangeTimer.delayStartEmotion(emotion);
    }

    Timer {
        property string emotion: "Idle"

        id: emotionChangeTimer
        interval: 1000;
        repeat: false

        function delayStartEmotion(newEmotion) {
            if (running)
                stop();

            emotion = newEmotion;
            start();
        }

        onTriggered: {
            face.state = emotion;
        }


    }
}
