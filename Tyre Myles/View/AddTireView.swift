//
//  NewTireView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/24/21.
//

import SwiftUI

struct AddTireView: View {
	@Environment(\.dismiss) var dismiss

	@EnvironmentObject var model: CoreDataModel

	@State private var name = ""
	@State private var seasonType: TyreModel.SeasonType = .allSeason
	@State private var tireStatus: TyreModel.TireStatus = .inStorage
	@State private var installDate = Date()
	@State private var removalDate = Date()
	@State private var installMilage: Double? = nil
	@State private var removalMilage: Double? = nil
	@State private var totalTyreMiles: Double? = nil

	@FocusState private var focusedField: Field?
	@FocusState private var mileageIsFocused: Bool

	enum Field {
		case name
		case install
		case removal
	}

	// Save button outline.
	let linearGradient = LinearGradient(gradient: Gradient(colors: [.gray, .white, .gray]), startPoint: .top, endPoint: .bottom)


	var body: some View {
		ScrollView {

			VStack {
				Picker("Season", selection: $seasonType) {
					Text("Summer")
						.tag(TyreModel.SeasonType.summer)
					Text("All Season")
						.tag(TyreModel.SeasonType.allSeason)
					Text("Winter")
						.tag(TyreModel.SeasonType.winter)
				}
				.padding([.leading, .trailing])
				.pickerStyle(.segmented)

				Group {
					TextField("Tire Name", text: $name)
						.focused($focusedField, equals: .name)
						.keyboardType(.alphabet)
						.submitLabel(.next)
						.padding(.top, 10)
					TextField("Milage on Vehicle", value: $installMilage, format: .number)
						.focused($focusedField, equals: .install)
						.focused($mileageIsFocused)
					TextField("Removal Mileage", value: $removalMilage, format: .number)
						.focused($focusedField, equals: .removal)
						.focused($mileageIsFocused)
				}
				.keyboardType(.numberPad)
				.textFieldStyle(.roundedBorder)
				.padding([.leading, .trailing])

				HStack {
					Spacer()
					Button {
						mileageIsFocused = false
					} label: {
						Image(systemName: "keyboard.chevron.compact.down")
					}.disabled(focusedField == .name || focusedField == nil)
				}.padding(.trailing)

				Group {
					Text("Enter Date Values")
						.font(.title2)
						.padding(.top, 40)
					DatePicker("Install Date", selection: $installDate, displayedComponents: .date)

					Picker("Wheel Status", selection: $tireStatus) {
						Text("On Vehicle").tag(TyreModel.TireStatus.onVehicle)
						Text("In Storage").tag(TyreModel.TireStatus.inStorage)
					}
					.pickerStyle(.segmented)
					.padding(.vertical)

					if tireStatus == .inStorage {
						DatePicker("Removal Date", selection: $removalDate, in: installDate..., displayedComponents: .date)
					}
				}.padding(.horizontal)

				Spacer()

				SaveButton
			}
			.alert(model.errorDetails?.title ?? "NIL Error", isPresented: $model.isPresentingAlert, presenting: model.errorDetails) { detail in
				Button("OK", role: .cancel) {
					// No Action Taken.
				}
			} message: { detail in
				Text(detail.message)
			}


		}// End of ScrollView
		.navigationBarTitle(Text("Add New Tire"))

		.onSubmit {
			// move text focus to next field upon entry.
			switch focusedField {
				case .name:
					focusedField = .install
				case .install:
					// not used as of 11/23/21 but reserving logic for possible future use.
					focusedField = .removal
				case .removal:
					focusedField = nil
				case .none:
					focusedField = nil
			}
		}


	}


	private var SaveButton: some View {
		Button {
			save()
		} label: {
			Capsule()
				.stroke(linearGradient, lineWidth: 2)
				.frame(height: 50)
				.overlay(Text("Save")
							.font(.title.bold())
							.foregroundColor(.primary)
				)
		}
		.padding()
		.disabled(tireStatus == .inStorage && (name.isEmpty || removalMilage == 0))
		.opacity(tireStatus == .inStorage && (name.isEmpty || removalMilage == 0) ? 0.25 : 1.0)
	}

	private func save() {
		let newTire = TyreModel(installMiles: installMilage ?? 0, removalMiles: removalMilage ?? 0, name: name, type: seasonType, status: tireStatus, installDate: installDate, removalDate: removalDate)

		model.addNew(tire: newTire)

		if !model.isPresentingAlert { dismiss() }
	}

}


#if DEBUG
struct NewTireView_Previews: PreviewProvider {

    static var previews: some View {
		AddTireView()
			.preferredColorScheme(.light)
    }
}
#endif
