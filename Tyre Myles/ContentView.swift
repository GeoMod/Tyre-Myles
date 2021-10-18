//
//  ContentView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/18/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
				  animation: .default)
    private var items: FetchedResults<Item>

	let tireImages = ["Summer", "Winter"]

	@State private var summerSelected = false


	var body: some View {
		ZStack {
			Color("Background").ignoresSafeArea()
			VStack(alignment: .leading) {
				Title
				HStack(spacing: 30) {
					ForEach(tireImages, id: \.self) { tire in
						Button {
							summerSelected.toggle()
						} label: {
							VStack {
								Image(tire)
									.resizable()
									.padding()
									.frame(width: 150, height: 150)
									.background { summerSelected ? Color.gray : Color.white }
									.clipShape(RoundedRectangle(cornerRadius: 18))
								Text(tire)
									.foregroundColor(.white)
									.font(Font.system(size: 26))
							}
						}

					}
				}
				Spacer()
			}

		}
	}

	private var Title: some View {
		Text("Tyre Myles")
			.font(Font.system(size: 40, weight: .semibold, design: .rounded))
			.foregroundStyle(LinearGradient(gradient: cARGradientColors, startPoint: .leading, endPoint: .trailing))
			.foregroundColor(.white)
			.padding(.leading)
	}


}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
		//.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
