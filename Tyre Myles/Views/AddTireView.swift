//
//  NewTireView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/24/21.
//

import SwiftUI

struct AddTireView: View {
	@Environment(\.dismiss) var dismiss

	@EnvironmentObject var dataModel: CoreDataModel
	@EnvironmentObject var tireViewModel: TyreViewModel

	@State private var name = ""
	@State private var seasonType: TireType = .allSeason
	@State private var tireStatus: TireStatus = .inStorage
	@State private var installDate = Date()
	@State private var removalDate = Date()
	@State private var installMilage: Double? = nil
	@State private var removalMilage: Double? = nil


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
						.tag(TireType.summer)
					Text("All Season")
						.tag(TireType.allSeason)
					Text("Winter")
						.tag(TireType.winter)
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
						.keyboardType(.numberPad)
					TextField("Removal Mileage", value: $removalMilage, format: .number)
					// Causing this to be .disabled will result in a warning about updating the view while not on the main thread.
					// Unsure why. 11/23/21
						.focused($mileageIsFocused)
						.keyboardType(.numberPad)
				}
				.textFieldStyle(.roundedBorder)
				.padding([.leading, .trailing])

				HStack {
					Spacer()
					Button {
						mileageIsFocused = false
					} label: {
						Image(systemName: "keyboard.chevron.compact.down")
					}
				}.padding(.trailing)

				Group {
					Text("Enter Date Values")
						.font(.title2)
						.padding(.top, 40)
					DatePicker("Install Date", selection: $installDate, displayedComponents: .date)

					Picker("Wheel Status", selection: $tireStatus) {
						Text("On Vehicle").tag(TireStatus.onVehicle)
						Text("In Storage").tag(TireStatus.inStorage)
					}
					.pickerStyle(.segmented)
					.padding(.vertical)

					if tireStatus == .inStorage {
						DatePicker(selection: $removalDate, in: installDate..., displayedComponents: .date) { Text("Removal Date") }
					}
				}.padding(.horizontal)

				Spacer()

				SaveButton
			}
			.alert("Mileage Entry Error", isPresented: $tireViewModel.isShowingAlert) {
				Button(role: .cancel) {
					removalMilage = 0
				} label: {
					Text("OK")
				}
			} message: {
				Text(tireViewModel.errorMessage)
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
			checkTireMileageValues()
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


	private func checkTireMileageValues() {
		tireViewModel.checkLogicalMileageValues(install: installMilage, removal: removalMilage, status: tireStatus)

		if !tireViewModel.isShowingAlert {
			save()
		}
	}

	private func save() {
		dataModel.saveTireProfileWith(name: name, season: seasonType, status: tireStatus, installMiles: installMilage,
									  removalMiles: removalMilage, installDate: installDate,
									  removallDate: removalDate)

		dismiss()
	}

	private func cancel() {
		dismiss()
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
