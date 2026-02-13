import qs.components
import qs.services
import qs.config
import qs.utils
import QtQuick

Item {
    id: root

    readonly property var weatherMap: {
        "Light rain": "Ujan tipis-tipis",
        "Heavy intensity rain": "Ujan deres pol",
        "Moderate rain": "Ujan biasa aja",
        "Overcast": "Mendung syahdu",
        "Clear sky": "Cerah pol!",
        "Scattered clouds": "Awan dikit-dikit",
        "Broken clouds": "Berawan manja",
        "Few clouds": "Cerah berawan",
        "Thunderstorm": "Gluduk, Ngeri!",
        "Drizzle": "Gerimis Mengundang",
        "Mist": "Banyak Kabut",
        "Fog": "Pandangan Kabur",
        "Haze": "Jakarta Berasap",
        "Smoke": "Lagi Fogging?",
        "Dust": "Debu Jalanan",
        "Squalls": "Angin Ribut",
        "Tornado": "Ada Puting Beliung!",
        "Rain": "Lagi Hujan, Neduh!",
        "Snow": "Salju (Hah?!)"
    }

    anchors.centerIn: parent

    implicitWidth: icon.implicitWidth + info.implicitWidth + info.anchors.leftMargin

    Component.onCompleted: Weather.reload()

    MaterialIcon {
        id: icon

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        animate: true
        text: Weather.icon
        color: Colours.palette.m3secondary
        font.pointSize: Appearance.font.size.extraLarge * 2
    }

    Column {
        id: info

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: icon.right
        anchors.leftMargin: Appearance.spacing.large

        spacing: Appearance.spacing.small

        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter

            animate: true
            text: Weather.temp
            color: Colours.palette.m3primary
            font.pointSize: Appearance.font.size.extraLarge
            font.weight: 500
        }

        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter

            animate: true
            text: weatherMap[Weather.description] || Weather.description

            elide: Text.ElideRight
            width: Math.min(implicitWidth, root.parent.width - icon.implicitWidth - info.anchors.leftMargin - Appearance.padding.large * 2)
        }
    }
}
