import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/tracking/domain/entities/poi_entity.dart';

abstract interface class TrackingLocalDataSource {
  Future<Either<Exception, List<PoiEntity>>> getUdmurtiaPois();
  Future<void> saveVisitedPoiId(String id);
  Future<List<String>> getVisitedPoiIds();
}

@LazySingleton(as: TrackingLocalDataSource)
final class TrackingLocalDataSourceImpl implements TrackingLocalDataSource {
  final Box<String> visitedBox;
  final FlutterSecureStorage storage;

  const TrackingLocalDataSourceImpl(this.visitedBox, this.storage);

  @override
  Future<void> saveVisitedPoiId(String id) async {
    final phone = await storage.read(key: 'active_user_phone');
    if (phone == null) return;

    final currentStr = visitedBox.get(phone) ?? '';
    final list = currentStr.split(',').where((e) => e.isNotEmpty).toList();
    
    if (!list.contains(id)) {
      list.add(id);
      await visitedBox.put(phone, list.join(','));
    }
  }

  @override
  Future<List<String>> getVisitedPoiIds() async {
    final phone = await storage.read(key: 'active_user_phone');
    if (phone == null) return [];

    final currentStr = visitedBox.get(phone) ?? '';
    return currentStr.split(',').where((e) => e.isNotEmpty).toList();
  }

  @override
  Future<Either<Exception, List<PoiEntity>>> getUdmurtiaPois() async {
    const pois = [
      PoiEntity(
        id: '1',
        title: 'Музей М.Т. Калашникова',
        description:
            'Оружейный музей, посвященный жизни и разработкам М.Т. Калашникова.',
        latitude: 56.850703,
        longitude: 53.206610,
      ),
      PoiEntity(
        id: '2',
        title: 'Лудорвай',
        description:
            'Архитектурно-этнографический музей-заповедник под открытым небом.',
        latitude: 56.746786,
        longitude: 53.059506,
      ),
      PoiEntity(
        id: '3',
        title: 'Свято-Михайловский собор',
        description: 'Величественный православный храм на холме в Ижевске.',
        latitude: 56.849601,
        longitude: 53.205359,
      ),
      PoiEntity(
        id: '4',
        title: 'Зоопарк Удмуртии',
        description: 'Один из крупнейших и лучших зоологических парков России.',
        latitude: 56.865537,
        longitude: 53.174118,
      ),
      PoiEntity(
        id: '5',
        title: 'Удмуртский государственный цирк',
        description: 'Культурное сердце Ижевска с яркими шоу-программами.',
        latitude: 56.841084,
        longitude: 53.210874,
      ),
      PoiEntity(
        id: 'word_1',
        title: 'Удмуртское слово зоны: "Зечбуресь!"',
        description:
            'Вы находитесь в историческом центре Ижевска! По-удмуртски "Здравствуйте" звучит как "Зечбуресь".',
        latitude: 56.861860,
        longitude: 53.232428,
      ),
      PoiEntity(
        id: '6',
        title: 'Дача Башенина (Сарапул)',
        description:
            'Архитектурная жемчужина Прикамья, купеческая усадьба начала XX века.',
        latitude: 56.472718,
        longitude: 53.820927,
      ),
      PoiEntity(
        id: '7',
        title: 'Музей-усадьба П.И. Чайковского (Воткинск)',
        description:
            'Место рождения великого композитора на берегу живописного пруда.',
        latitude: 56.328957,
        longitude: 36.747547,
      ),
      PoiEntity(
        id: 'word_2',
        title: 'Удмуртское слово зоны: "Тау!"',
        description:
            'Путешествуя по Глазову, не забудьте поблагодарить местных. По-удмуртски "Спасибо" — "Тау".',
        latitude: 58.136884,
        longitude: 52.654834,
      ),
    ];

    return const Right(pois);
  }
}
