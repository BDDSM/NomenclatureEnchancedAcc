﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПИН_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ПараметрыКорзины") Тогда
		Возврат;
	КонецЕсли;
	
	ВидОперацииПриОткрытии = Перечисления.ВидыОперацийРеализацияТоваров.ПродажаКомиссия;
	Объект.ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.ПродажаКомиссия;
	ПараметрыКорзины = Параметры.ПараметрыКорзины;
	Если ПараметрыКорзины.Свойство("АдресКорзиныВХранилище") И ЗначениеЗаполнено(ПараметрыКорзины.АдресКорзиныВХранилище) Тогда
		ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(ПараметрыКорзины.АдресКорзиныВХранилище);
		ТаблицаТовары = ТаблицаДляЗагрузки.Скопировать(Новый Структура("Услуга", Ложь));
		Объект.Товары.Загрузить(ТаблицаТовары);
		ТаблицаУслуги = ТаблицаДляЗагрузки.Скопировать(Новый Структура("Услуга", Истина));
		Объект.Услуги.Загрузить(ТаблицаУслуги);
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из Объект.Товары Цикл
		ПриИзмененииНоменклатурыТовары(СтрокаТаблицы);
	КонецЦикла;
	Для Каждого СтрокаТаблицы Из Объект.Услуги Цикл
		ПриИзмененииНоменклатурыУслуги(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ИзменениеНоменклатуры

&НаСервере
Процедура ПриИзмененииНоменклатурыТовары(СтрокаТаблицы)
	
	// Получим общие параметры обработки для реквизитов документа
	ПараметрыОбработки = ПИН_ПодготовитьПараметрыОбработкиТоварыНоменклатураПриИзменении(
		ЭтаФорма, СтрокаТаблицы);
	
	// Дополнительные поля, требующиеся для заполнения добавленных колонок табличного поля текущей формы.
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("Всего", СтрокаТаблицы.Всего);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("СчетДоходовВедетсяУчетПоНоменклатурнымГруппам", СтрокаТаблицы.СчетДоходовВедетсяУчетПоНоменклатурнымГруппам);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("СчетУчетаЗабалансовый", СтрокаТаблицы.СчетУчетаЗабалансовый);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("ПродукцияМаркируемаяДляГИСМ", СтрокаТаблицы.ПродукцияМаркируемаяДляГИСМ);
	
	ЗаполнитьПараметрыОбъектаДляЗаполненияДобавленныхКолонок(ЭтаФорма, ПараметрыОбработки.ДанныеОбъекта);
	
	ТоварыНоменклатураПриИзмененииНаСервере(
		ПараметрыОбработки.ДанныеСтрокиТаблицы,
		ПараметрыОбработки.ДанныеОбъекта,
		ПараметрыОбработки.СчетаУчетаКЗаполнению);
	
	ИсключаемыеПоля = "";
	Если СтрокаТаблицы.Цена <> 0 Тогда
		ИсключаемыеПоля = "Цена, Сумма, СуммаНДС, Всего";
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыОбработки.ДанныеСтрокиТаблицы,, ИсключаемыеПоля);
	ОтобразитьСубконтоСчетаДоходовТовары = ОтобразитьСубконтоСчетаДоходовТовары ИЛИ НЕ СтрокаТаблицы.СчетДоходовВедетсяУчетПоНоменклатурнымГруппам;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииНоменклатурыУслуги(СтрокаТаблицы)
	
	// Получим общие параметры обработки для реквизитов документа
	ПараметрыОбработки = ПИН_ПодготовитьПараметрыОбработкиУслугиНоменклатураПриИзменении(
		ЭтаФорма, СтрокаТаблицы);
	
	// Дополнительные поля, требующиеся для заполнения добавленных колонок табличного поля текущей формы.
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("Всего", СтрокаТаблицы.Всего);
	ПараметрыОбработки.ДанныеСтрокиТаблицы.Вставить("СчетДоходовВедетсяУчетПоНоменклатурнымГруппам", СтрокаТаблицы.СчетДоходовВедетсяУчетПоНоменклатурнымГруппам);
	
	ЗаполнитьПараметрыОбъектаДляЗаполненияДобавленныхКолонок(ЭтаФорма, ПараметрыОбработки.ДанныеОбъекта);
	
	УслугиНоменклатураПриИзмененииНаСервере(
		ПараметрыОбработки.ДанныеСтрокиТаблицы,
		ПараметрыОбработки.ДанныеОбъекта,
		ПараметрыОбработки.СчетаУчетаКЗаполнению);
	
	ИсключаемыеПоля = "";
	Если СтрокаТаблицы.Цена <> 0 Тогда
		ИсключаемыеПоля = "Цена, Сумма, СуммаНДС, Всего";
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПараметрыОбработки.ДанныеСтрокиТаблицы,,ИсключаемыеПоля);
	
	ОтобразитьСубконтоСчетаДоходовУслуги = ОтобразитьСубконтоСчетаДоходовУслуги ИЛИ НЕ СтрокаТаблицы.СчетДоходовВедетсяУчетПоНоменклатурнымГруппам;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПИН_ПодготовитьПараметрыОбработкиТоварыНоменклатураПриИзменении(Форма, СтрокаТабличнойЧасти) Экспорт
	
	Объект = Форма.Объект;
	ЭтоКомиссия = РеализацияТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ЭтоКомиссия");
	РеализацияВЕАЭС       = РеализацияТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "РеализацияВЕАЭС");
	ВедетсяУчетНДСПоФЗ150 = РеализацияТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ВедетсяУчетНДСПоФЗ150");
	ВедетсяУчетНДСПоФЗ335 = РеализацияТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ВедетсяУчетНДСПоФЗ335");
	ПокупательНалоговыйАгентПоНДС = РеализацияТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ПокупательНалоговыйАгентПоНДС");
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"Номенклатура, ЕдиницаИзмерения, Коэффициент, Количество,
		|Цена, Сумма, СтавкаНДС, СуммаНДС,
		|НомерГТД, СтранаПроисхождения,
		|ПродукцияМаркируемаяДляГИСМ, КодТНВЭД,
		|СчетУчета, СчетДоходов, СчетРасходов, Субконто, СчетУчетаНДСПоРеализации, ПереданныеСчетУчета, СчетУчетаПартионный");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТабличнойЧасти);
	
	ДанныеОбъекта = Новый Структура(
		"Дата, ВидОперации, Организация, ДеятельностьНаПатенте,
		|ВалютаДокумента, КурсВзаиморасчетов, КратностьВзаиморасчетов,
		|СуммаВключаетНДС, ДоговорКонтрагента,
		|ЭтоКомиссия, Реализация, ДокументБезНДС, РеализацияВЕАЭС, 
		|ВедетсяУчетНДСПоФЗ150, ВедетсяУчетНДСПоФЗ335, ПокупательНалоговыйАгентПоНДС");
		
	Если Форма.ИспользоватьТипыЦенНоменклатуры Тогда
		ДанныеОбъекта.Вставить("ТипЦен");
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.ЭтоКомиссия = ЭтоКомиссия;
	ДанныеОбъекта.РеализацияВЕАЭС = РеализацияВЕАЭС;
	ДанныеОбъекта.ВедетсяУчетНДСПоФЗ150 = ВедетсяУчетНДСПоФЗ150;
	ДанныеОбъекта.ВедетсяУчетНДСПоФЗ335 = ВедетсяУчетНДСПоФЗ335;
	ДанныеОбъекта.ПокупательНалоговыйАгентПоНДС = ПокупательНалоговыйАгентПоНДС;
	ДанныеОбъекта.Реализация  = Истина;
	
	ПараметрыЗаполненияСчетовУчета = РеализацияТоваровУслугФормыКлиентСервер.НачатьЗаполнениеСчетовУчета(
		"Товары.Номенклатура",
		Объект,
		СтрокаТабличнойЧасти,
		ДанныеОбъекта,
		ДанныеСтрокиТаблицы);
	
	ПараметрыОбработки = Новый Структура();
	ПараметрыОбработки.Вставить("ДанныеСтрокиТаблицы", 	 ДанныеСтрокиТаблицы);
	ПараметрыОбработки.Вставить("ДанныеОбъекта", 		 ДанныеОбъекта);
	ПараметрыОбработки.Вставить("СчетаУчетаКЗаполнению", ПараметрыЗаполненияСчетовУчета.КЗаполнению);
	
	Возврат ПараметрыОбработки;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПИН_ПодготовитьПараметрыОбработкиУслугиНоменклатураПриИзменении(Форма, СтрокаТабличнойЧасти) Экспорт
	
	Объект = Форма.Объект;
	ЭтоКомиссия = РеализацияТоваровУслугФормыКлиентСервер.ПолучитьРеквизитФормы(Форма, "ЭтоКомиссия");

	ДанныеСтрокиТаблицы = Новый Структура("Номенклатура, Содержание, Количество,
		|Цена, Сумма, СтавкаНДС, СуммаНДС,
		|СчетДоходов, СчетРасходов, Субконто, СчетУчетаНДСПоРеализации");
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТабличнойЧасти);
	
	ДанныеОбъекта = Новый Структура("Ссылка, Дата, ВидОперации, Организация, ДеятельностьНаПатенте,
		|Склад, ТипЦен, ВалютаДокумента, КурсВзаиморасчетов, КратностьВзаиморасчетов,
		|СуммаВключаетНДС, ДоговорКонтрагента,
		|ЭтоКомиссия, Реализация, ДокументБезНДС");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	ДанныеОбъекта.ЭтоКомиссия = ЭтоКомиссия;
	ДанныеОбъекта.Реализация  = Истина;
	
	ПараметрыЗаполненияСчетовУчета = РеализацияТоваровУслугФормыКлиентСервер.НачатьЗаполнениеСчетовУчета(
		"Услуги.Номенклатура",
		Объект,
		СтрокаТабличнойЧасти,
		ДанныеОбъекта,
		ДанныеСтрокиТаблицы);
	
	ПараметрыОбработки = Новый Структура();
	ПараметрыОбработки.Вставить("ДанныеСтрокиТаблицы", 	ДанныеСтрокиТаблицы);
	ПараметрыОбработки.Вставить("ДанныеОбъекта", 		ДанныеОбъекта);
	ПараметрыОбработки.Вставить("СчетаУчетаКЗаполнению", ПараметрыЗаполненияСчетовУчета.КЗаполнению);
	
	Возврат ПараметрыОбработки;
	
КонецФункции

#КонецОбласти